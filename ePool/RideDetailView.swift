//
//  RideDetailView.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/21/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class RideDetailView: UIViewController
{
    
    var topView = UIView()
    var trip = Trip()
    
    override func viewDidLayoutSubviews() {
        
        let bottom = self.view.safeAreaInsets.bottom
    }
    override func viewWillLayoutSubviews() {
        
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        
        setTopView()
        setBottomView()
        
        
    }
    
    func setTopView()
    {
        
        topView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.1)
        topView.backgroundColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 0.8235294118, alpha: 1)
        
        let tripLabel = UILabel()
        tripLabel.frame = CGRect(x: 60, y: (self.view.bounds.height * 0.1) / 2 , width: self.view.bounds.width - 120, height: 32)
        tripLabel.font = UIFont.systemFont(ofSize: 30.0)
        tripLabel.textAlignment = .center
        tripLabel.textColor = .white
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        tripLabel.adjustsFontSizeToFitWidth = true
        
        trip.name = "Parker Road DIART"
        trip.date = "JUL\n22"
        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
        
        tripLabel.text = "Upcomming Ride"
        topView.addSubview(tripLabel)
        
        
        
        self.view.addSubview(topView)
        
        let backbutton = UIButton(frame: CGRect(x: 15, y: (self.view.bounds.height * 0.1) - 50, width: 40, height: 40))
        backbutton.setImage(#imageLiteral(resourceName: "back button"), for: .normal)
        backbutton.addTarget(self, action:#selector(self.backPressed), for: .touchUpInside)
        self.view.addSubview(backbutton)
    }
    
    func setBottomView()
    {
        let origin = TripOriginDestination()
        origin.frame = CGRect(x: 0, y: self.view.bounds.height * 0.1, width: self.view.bounds.width / 2, height: self.view.bounds.height * 0.2 + 165)
        origin.route = "400 Daisy Dr., Allen, TX"
        origin.arival = "11:25 am"
        origin.type = false
        origin.startTime = "10:45 am"
        origin.mapView.lat = CLLocationDegrees(floatLiteral: 33.1067262)
        origin.mapView.long = CLLocationDegrees(floatLiteral: -96.6751474)
        origin.mapView.annotationTitle = "400 Daisy Dr"
        origin.totalHeight = self.view.bounds.height
        
        let destination = TripOriginDestination()
        destination.frame = CGRect(x: self.view.bounds.width / 2, y: self.view.bounds.height * 0.1, width: self.view.bounds.width / 2, height: self.view.bounds.height * 0.2 + 165)
        destination.route = "Ikea, 7171 Ikea Dr., Frisco, TX"
        destination.arival = "2:15 pm"
        destination.type = true
        destination.startTime = "2:55 pm"
        destination.totalHeight = self.view.bounds.height
        destination.mapView.lat = CLLocationDegrees(floatLiteral: 33.0942698)
        destination.mapView.long = CLLocationDegrees(floatLiteral: -96.8227465)
        destination.mapView.annotationTitle = "Ikea"
        self.view.addViews(views: [origin,destination])
        
        let description = UITextView()
        description.frame = CGRect(x: 10, y: destination.frame.maxY, width: self.view.bounds.width - 20, height: self.view.bounds.height - (destination.frame.maxY + 70))
        description.text = "Our weekly route to Ikea, where you can get everything you need in a household. Please be ready for pickup on time. Our bus will only wait till scheduled pickup time."
        description.textColor = .black
        description.textAlignment = .justified
        description.font = UIFont.systemFont(ofSize: 15.0)
        description.isEditable = false
        description.sizeToFit()
        self.view.addSubview(description)
        
        let ticketNuml = UILabel()
        ticketNuml.frame = CGRect(x: 10, y:  description.frame.maxY + 10, width: self.view.bounds.width - 20, height: 22)
        ticketNuml.font = UIFont.systemFont(ofSize: 20.0)
        ticketNuml.textAlignment = .left
        ticketNuml.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        ticketNuml.adjustsFontSizeToFitWidth = true
        ticketNuml.text = "TICKET NUMBER"
        self.view.addSubview(ticketNuml)
        
        let ticketNum = UILabel()
        ticketNum.frame = CGRect(x: 10, y:  ticketNuml.frame.maxY, width: self.view.bounds.width - 20, height: 22)
        ticketNum.font = UIFont.systemFont(ofSize: 20.0)
        ticketNum.textAlignment = .left
        ticketNum.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        ticketNum.adjustsFontSizeToFitWidth = true
        ticketNum.text = "8247081437814708"
        self.view.addSubview(ticketNum)
        
        let qrImage = UIImageView()
        qrImage.frame = CGRect(x: 10, y: ticketNum.frame.maxY + 10, width: self.view.bounds.width - 10, height: self.view.bounds.height - (ticketNum.frame.maxY + topView.bounds.height))
        qrImage.image = #imageLiteral(resourceName: "Screen Shot 2019-07-20 at 21.20")
        qrImage.contentMode = .scaleAspectFit
        self.view.addSubview(qrImage)
    }

    @objc func viewTapped (_ sender : UITapGestureRecognizer)
    {
        print("purchaseWithEbayPressed")
        sender.view?.shake()
    }
    @objc func backPressed()
    {
        print("Back buttton triggerd")
        let animation = CATransition()
        animation.type = .push
        animation.subtype = .fromBottom
        animation.duration = 0.3
        self.view.window!.layer.add(animation, forKey: nil)
        self.dismiss(animated: false, completion: nil)
    }
}
