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

//     var mapView = MapView()
    
//     override func viewDidLoad() {
//         super.viewDidLoad()
//         // Do any additional setup after loading the view.
        
//         self.present(HomeTBVC(), animated: false, completion: nil)
//         //addMap()
//     }
    
    
// //    func addMap()
// //    {
// //        self.addChild(mapView)
// //        self.view.addSubview(mapView.view)
// //        let place1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.6862002, longitude: -122.408004))
// //        let place2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 37.7862002, longitude: -122.408004))
// //        mapView.createRoute(sourcePlacemark: place1, destinationPlacemark: place2)
// //    }
// }
}

extension ViewController: eBayServiceDelegate {
  func eBayDidLoadUserCredentials(_ eBayService: eBayService) {
    eBayService.listListings { listing in
      print(listing)
    }
  }
}
