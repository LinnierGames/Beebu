//
//  eBayViewService.swift
//  ePool
//
//  Created by Erick Sanchez on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit
import WebKit
import Moya
import Result
import SwiftyXML

protocol eBayServiceDelegate: class {
  func eBayDidLoadUserCredentials(_ eBayService: eBayService)
}

struct Listing {
  let itemId: String
  let title: String
  let price: Double
  let date: Date
  let description: String
  let thumbnail: URL?
  let storeUrl: URL?
}

struct PurchasedListing {
  let roundTrip: String
  let origin: String
  let destination: String
  let outboundPickup: String
  let outboundArrival: String
  let inboundPickup: String
  let inboundArrival: String
}

extension Listing {
  fileprivate init(_ listingData: ListingData) {
    self.itemId = listingData.itemId
    self.title = listingData.title
    self.price = listingData.price
    self.date = listingData.date
    self.description = listingData.description
    self.thumbnail = listingData.thumbnail
    self.storeUrl = listingData.storeUrl
  }
}

struct ListingData: Decodable {
  let itemId: String
  let title: String
  let price: Double
  let date: Date
  let description: String
  let thumbnail: URL?
  let storeUrl: URL?
}

class eBayService {
  static let clientID = "ErickSan-Sample-PRD-cd8d798b5-a58960b7"
  static let clientSecret = "PRD-d8d798b5fe8a-d704-4c61-b082-9dc2"
  static let ruName = "Erick_Sanchez-ErickSan-Sample-eflcxsc"

  weak var delegate: eBayServiceDelegate? {
    didSet {
      self.noftifyIfUserTokenAlreadyExists()
    }
  }
  var currentAuthViewController: EbayVc? = nil

  private var accessToken: String? {
    return UserDefaults.standard.string(forKey: "USER_ACCESS_TOKEN")
  }
  private let eBayApi = MoyaProvider<eBayAPI>()
  private let eBayFindApi = MoyaProvider<eBayFindAPI>()
  private let eBayTradingApi = MoyaProvider<eBayTradingAPI>()

  func listListings(_ completion: @escaping ([Listing]) -> Void) {
    self.eBayFindApi.request(
      .findAllListings,
      completion: self.handleResponse(data: { data in
        guard let data = data else { return }
        let xml = XML(data: data)!
        guard Int(try! xml.searchResult.getXML().attributes["count"] ?? "0")! != 0 else {
          return completion([])
        }

        let listingIds = xml.searchResult.item.map { $0.itemId.stringValue }

        self.populate(listingIds) { listingData in
          completion(listingData?.map(Listing.init) ?? [])
        }
      }))
  }

  func listPurchasedItems() -> (currentListings: [PurchasedListing], pastListings: [PurchasedListing]) {
    return (
      [
        PurchasedListing(
          roundTrip: "JUL 22",
          origin: "400 Daisy Dr., Allen, TX 75013",
          destination: "Ikea at Frisco",
          outboundPickup: "10:45 am",
          outboundArrival: "11:25 am",
          inboundPickup: "2:15 pm",
          inboundArrival: "2:55 pm")
      ],
      [
        PurchasedListing(
          roundTrip: "JUL 5",
          origin: "400 Daisy Dr., Allen, TX 75013",
          destination: "Sprouts Farmers Market at Preston",
          outboundPickup: "10:45 am",
          outboundArrival: "11:25 am",
          inboundPickup: "2:15 pm",
          inboundArrival: "2:55 pm")
      ]
    )
  }

  // MARK: - Private

  private func populate(_ ids: [String], completion: @escaping ([ListingData]?) -> Void) {
    guard let token = self.accessToken else {
      return completion(nil)
    }

    let payload = UserAuthPayload(userToken: token)
    let dg = DispatchGroup()
    var listingData: [ListingData] = []
    for id in ids {
      dg.enter()
      self.eBayTradingApi.request(
        .getItem(id: id, auth: payload),
        completion: self.handleResponse(data: { data in
          guard let data = data else { return }
          let xml = XML(data: data)!

          let itemDate = Date() // ItemSpecifics.NameValueList.Name.(Event Date/Event Time)

          let title = xml.Item.Title.stringValue
          let prefix = "$$Beebu$$ - "
          let formattedTitle: String
          if title.hasPrefix(prefix) {
            formattedTitle = String(title.dropFirst(prefix.count))
          } else {
            formattedTitle = title
          }

          let description = xml.Item.Description.stringValue
          let formattedDescription = description.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)

          listingData.append(ListingData(
            itemId: xml.Item.ItemID.stringValue,
            title: formattedTitle,
            price: Double(xml.Item.SellingStatus.CurrentPrice.stringValue) ?? 0,
            date: itemDate,
            description: formattedDescription,
            thumbnail: URL(string: xml.Item.PictureDetails.PictureURL.stringValue),
            storeUrl: URL(string: xml.Item.ListingDetails.ViewItemURL.stringValue)))
          dg.leave()
        }
      ))
    }

    dg.notify(queue: .main) {
      completion(listingData)
    }
  }

  private func noftifyIfUserTokenAlreadyExists() {
    if UserDefaults.standard.string(forKey: "USER_ACCESS_TOKEN") != nil {
      self.delegate?.eBayDidLoadUserCredentials(self)
    }
  }

  private func fetchUserAccessToken(from code: String) {
    self.eBayApi.request(.userToken(code: code), completion: self.handleResponse(data: { data in
      guard let data = data,
        let object = try? JSONSerialization
          .jsonObject(
            with: data,
            options: JSONSerialization.ReadingOptions.allowFragments
          ) as? [String: Any]
      else {
        return print("failed")
      }

      let accessToken = object["access_token"]! as! String
      self.store(accessToken)
      self.delegate?.eBayDidLoadUserCredentials(self)
    }))
  }

  private func handleResponse<T: Decodable>(_ converter: @escaping (T?) -> Void) -> (Result<Moya.Response, Moya.MoyaError>) -> Void {
    return self.handleResponse(data: { data in
      guard let data = data else {
        return converter(nil)
      }

      guard let converted = try? JSONDecoder().decode(T.self, from: data) else {
        return converter(nil)
      }

      converter(converted)
    })
  }

  private func handleResponse(data converter: @escaping (Data?) -> Void) -> (Result<Moya.Response, Moya.MoyaError>) -> Void {
    return { result in
      switch result {
      case .success(let response):
        converter(response.data)
      case .failure(let error):
        assertionFailure(error.localizedDescription)
        converter(nil)
      }
    }
  }

  private func store(_ accessToken: String) {
    UserDefaults.standard.set(accessToken, forKey: "USER_ACCESS_TOKEN")
    print(accessToken)
  }
}

extension eBayService: EbayVcDelegate {

  func authViewController() -> UIViewController {
    let vc = EbayVc()
    self.currentAuthViewController = vc
    self.currentAuthViewController?.delegate = self

    return vc
  }

  func didFetch(_ code: String) {
    self.fetchUserAccessToken(from: code)
  }
}

protocol EbayVcDelegate: class {
  func didFetch(_ code: String)
}

class EbayVc: UIViewController, WKNavigationDelegate, WKUIDelegate {
  var webview: WKWebView {
    return self.view as! WKWebView
  }

  weak var delegate: EbayVcDelegate?

  override func loadView() {
    let config = WKWebViewConfiguration.init()
    let webView = WKWebView.init(frame: .zero, configuration: config)
    self.view = webView
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    self.webview.uiDelegate = self
    self.webview.navigationDelegate = self
    let authRequest = URLRequest(url: URL(string: "https://auth.ebay.com/oauth2/authorize?client_id=ErickSan-Sample-PRD-cd8d798b5-a58960b7&response_type=code&redirect_uri=Erick_Sanchez-ErickSan-Sample-eflcxsc&scope=https://api.ebay.com/oauth/api_scope%20https://api.ebay.com/oauth/api_scope/sell.marketing.readonly%20https://api.ebay.com/oauth/api_scope/sell.marketing%20https://api.ebay.com/oauth/api_scope/sell.inventory.readonly%20https://api.ebay.com/oauth/api_scope/sell.inventory%20https://api.ebay.com/oauth/api_scope/sell.account.readonly%20https://api.ebay.com/oauth/api_scope/sell.account%20https://api.ebay.com/oauth/api_scope/sell.fulfillment.readonly%20https://api.ebay.com/oauth/api_scope/sell.fulfillment%20https://api.ebay.com/oauth/api_scope/sell.analytics.readonly%20https://api.ebay.com/oauth/api_scope/sell.finances")!)
    self.webview.load(authRequest)
  }

  func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    guard case .formSubmitted = navigationAction.navigationType else {
      return decisionHandler(.allow)
    }

    if navigationAction
      .request
      .url!
      .absoluteString
      .hasPrefix(
        "https://signin.ebay.com/ws/eBayISAPI.dll?ThirdPartyAuthSucessFailure&isAuthSuccessful=true"
      ) {
      if let code = URLComponents.init(url: navigationAction.request.url!, resolvingAgainstBaseURL: false)!.queryItems!.first(where: { $0.name == "code" })?.value {
        self.delegate?.didFetch(code)
      }
      self.presentingViewController?.dismiss(animated: true)
    }
    decisionHandler(.allow)
  }
}
