//
//  eBayViewService.swift
//  ePool
//
//  Created by Erick Sanchez on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit
import WebKit

protocol eBayServiceDelegate: class {
  func eBayDidLoadUserCredentials(_ eBayService: eBayService)
}

class eBayService: EbayVcDelegate {
  let clientID = "ErickSan-Sample-PRD-cd8d798b5-a58960b7"
  let clientSecret = "PRD-d8d798b5fe8a-d704-4c61-b082-9dc2"
  let ruName = "Erick_Sanchez-ErickSan-Sample-eflcxsc"

  weak var delegate: eBayServiceDelegate?
  var currentAuthViewController: EbayVc? = nil

  private var accessToken: String? {
    return UserDefaults.standard.string(forKey: "USER_ACCESS_TOKEN")
  }

  func authViewController() -> UIViewController {
    let vc = EbayVc()
    self.currentAuthViewController = vc
    self.currentAuthViewController?.delegate = self

    return vc
  }

  func didFetch(_ code: String) {
    self.fetchUserAccessToken(from: code)
  }

  private func fetchUserAccessToken(from code: String) {
    let urlUserToken = URL(string: "https://api.ebay.com/identity/v1/oauth2/token")!
    var request = URLRequest(url: urlUserToken)

    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    let authString = "\(self.clientID):\(self.clientSecret)"
    request.addValue(
      "Basic \(Data(authString.utf8).base64EncodedString())", forHTTPHeaderField: "Authorization")

    request.httpMethod = "POST"
    request.httpBody =
      "grant_type=authorization_code&code=\(code)&redirect_uri=\(self.ruName)"
        .data(using: String.Encoding.utf8)!
    URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        return print(error)
      }

      guard let data = data,
        let object = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
          return print("failed")
      }

      let accessToken = object["access_token"]! as! String
      self.store(accessToken)
      self.delegate?.eBayDidLoadUserCredentials(self)

    }.resume()
  }

  private func store(_ accessToken: String) {
    UserDefaults.standard.set(accessToken, forKey: "USER_ACCESS_TOKEN")
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
