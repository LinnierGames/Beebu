//
//  eBayAPI.swift
//  ePool
//
//  Created by Erick Sanchez on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import Moya

enum eBayFindAPI: TargetType {
  case findAllListings

  var baseURL: URL {
    return URL(string: "https://svcs.ebay.com/services/search/FindingService/v1")!
  }

  var path: String {
    switch self {
    case .findAllListings:
      return ""
    }
  }

  var method: Moya.Method {
    switch self {
    case .findAllListings:
      return .get
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case .findAllListings:
      let keywords = "$$ePool$$"
      let categoryID = "1306" // Tickets; Experiences:Other Tickets; Experiences
      return .requestParameters(
        parameters: [
          "categoryId": categoryID,
          "keywords": keywords
        ],
        encoding: URLEncoding.default)
    }
  }

  var headers: [String : String]? {
    switch self {
    case .findAllListings:
      return [
        "X-EBAY-SOA-SECURITY-APPNAME":eBayService.clientID,
        "X-EBAY-SOA-OPERATION-NAME":"findItemsAdvanced"
      ]
    }
  }
}

enum eBayAPI: TargetType {
  case userToken(code: String)

  var baseURL: URL {
    return URL(string: "https://api.ebay.com/identity/v1/")!
  }

  var path: String {
    switch self {
    case .userToken:
      return "oauth2/token/"
    }
  }

  var method: Moya.Method {
    switch self {
    case .userToken:
      return .post
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case .userToken(let code):
      let data =  "grant_type=authorization_code&code=\(code)&redirect_uri=\(eBayService.ruName)"
        .data(using: String.Encoding.utf8)!
      return .requestData(data)
    }
  }

  var headers: [String : String]? {
    switch self {
    case .userToken:
      let authString = "\(eBayService.clientID):\(eBayService.clientSecret)"
      return [
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
        "Basic \(Data(authString.utf8).base64EncodedString())"
      ]
    }
  }
}
