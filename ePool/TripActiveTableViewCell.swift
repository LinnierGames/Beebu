//
//  TripActiveTableViewCell.swift
//  ePool
//
//  Created by Noah Woodward on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import UIKit

class TripActiveTableViewCell: UITableViewCell {

  @IBOutlet weak var roundTrip: UILabel!
  @IBOutlet weak var origin: UILabel!
  @IBOutlet weak var destination: UILabel!
  @IBOutlet weak var outboundPickup: UILabel!
  @IBOutlet weak var outboundArrival: UILabel!
  @IBOutlet weak var inboundPickup: UILabel!
  @IBOutlet weak var inboundArrival: UILabel!
}
