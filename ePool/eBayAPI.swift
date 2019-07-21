//
//  eBayAPI.swift
//  ePool
//
//  Created by Erick Sanchez on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import Moya

enum eBayAPI: TargetType {
  case listListings
  case userToken(code: String)

  var baseURL: URL {
    return URL(string: "https://api.ebay.com/identity/v1/")!
  }

  var path: String {
    switch self {
    case .listListings:
      return ""
    case .userToken:
      return "oauth2/token/"
    }
  }

  var method: Moya.Method {
    switch self {
    case .listListings:
      return .get
    case .userToken:
      return .post
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case .listListings:
      return .requestPlain
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
    default:
      return [:]
    }
  }
}
