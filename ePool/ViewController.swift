//
//  ViewController.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit

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
    let alert = UIAlertController(title: "Logged in!", message: "the user is logged in!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
    self.present(alert, animated: true)
  }
}
