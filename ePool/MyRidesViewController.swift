//
//  MyRidesViewController.swift
//  ePool
//
//  Created by Noah Woodward on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit

class MyRidesViewController: UITableViewController {

  let eBay = eBayService()
  var currentListings: [PurchasedListing] = []
  var pastListings: [PurchasedListing] = []

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    self.tableView.separatorStyle = .none
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let result = self.eBay.listPurchasedItems()
    self.currentListings = result.currentListings
    self.pastListings = result.pastListings
    self.tableView.reloadData()
  }

}


extension MyRidesViewController {

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 2
  }

  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Active Trips"
    } else {
      return "Recent Rides"
    }
  }

  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
    returnedView.backgroundColor = .white

    let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width, height: 25))
    if section == 0 {
      label.text = "Active Trips"
    } else {
      label.text = "Recent Rides"
    }

    label.textColor = .lightGray
    label.font = UIFont.boldSystemFont(ofSize: 16)
    returnedView.addSubview(label)

    return returnedView

  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return [self.currentListings, self.pastListings][section].count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCell(withIdentifier: "tripActiveCell", for: indexPath) as! TripActiveTableViewCell
      cell.selectionStyle = .none

//      let listing = self.currentListings[indexPath.row]
//      cell.roundTrip.text = listing.roundTrip
//      cell.origin.text = listing.origin
//      cell.destination.text = listing.destination
//      cell.outboundPickup.text = listing.outboundPickup
//      cell.outboundArrival.text = listing.outboundArrival
//      cell.inboundPickup.text = listing.inboundPickup
//      cell.inboundArrival.text = listing.inboundArrival

      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: "tripPastCell", for: indexPath) as! TripPastTableViewCell
      cell.selectionStyle = .none

//      let listing = self.pastListings[indexPath.row]
//      cell.roundTrip.text = listing.roundTrip
//      cell.origin.text = listing.origin
//      cell.destination.text = listing.destination

      return cell
    }

  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 220
    } else {
      return 120
    }

  }
}

