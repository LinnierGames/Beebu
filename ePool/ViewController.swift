//
//  ViewController.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController {
  let eBay = eBayService()

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    self.eBay.delegate = self
  }

  @IBAction func pressSignIn(_ sender: Any) {
    let vc = self.eBay.authViewController()
    self.present(UINavigationController(rootViewController: vc), animated: true)
  }
}

extension ViewController: eBayServiceDelegate {
  func eBayDidLoadUserCredentials(_ eBayService: eBayService) {
    eBayService.listListings { listing in
      print(listing)
    }
  }
}
