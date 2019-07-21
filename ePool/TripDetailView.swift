//
//  TripDetailView.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit
import WebKit
class TripDetailView: UIViewController
{
    
    var trip = Trip()
    var topView = UIView()
    var buttonView = UIView()
    let eBay = eBayService()
    let webView = WKWebView()
    override func viewDidLayoutSubviews() {
        
        let bottom = self.view.safeAreaInsets.bottom
       buttonView.frame = CGRect(x: 20, y: self.view.bounds.height - (60 + bottom), width: self.view.bounds.width - 40, height: 60)
    }
    override func viewWillLayoutSubviews() {
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setTopView()
        setBottomButton()
        setBottomView()
        
        
    }
    
    func setTopView()
    {
        
        let backImage = UIImageView()
        backImage.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height:  self.view.bounds.height * 0.2)
        backImage.contentMode = .scaleToFill
        backImage.clipsToBounds = true
        backImage.alpha = 1
        backImage.downloaded(from: trip.backImageUrl!, contentMode: .scaleAspectFill)
        topView.addSubview(backImage)
        
        
        
        let tripLabel = UILabel()
        tripLabel.frame = CGRect(x: 65, y:  self.view.bounds.height * 0.2 - 50, width:  self.view.bounds.width - 65, height: 50)
        tripLabel.font = UIFont.systemFont(ofSize: 25.0)
        tripLabel.textAlignment = .left
        tripLabel.textColor = .white
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        tripLabel.adjustsFontSizeToFitWidth = true
        tripLabel.text = trip.name
        topView.addSubview(tripLabel)
        
        let dateLabel = UILabel()
        dateLabel.frame = CGRect(x: 15, y:  self.view.bounds.height * 0.2 - 60, width: 40, height: 50)
        dateLabel.numberOfLines = 2
        dateLabel.font = UIFont.systemFont(ofSize: 20.0)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
        //dateLabel.shadowColor = .black
        //dateLabel.shadowOffset = CGSize(width: -2, height: 2)
        dateLabel.adjustsFontSizeToFitWidth = true
        dateLabel.text = trip.date
        topView.addSubview(dateLabel)
        
        
        
        self.view.addSubview(topView)
        
        let backbutton = UIButton(frame: CGRect(x: 15, y: 30, width: 40, height: 40))
        backbutton.setImage(#imageLiteral(resourceName: "back button"), for: .normal)
        backbutton.addTarget(self, action:#selector(self.backPressed), for: .touchUpInside)
        self.view.addSubview(backbutton)
    }
    
    func setBottomView()
    {
//        let origin = TripOriginDestination()
//        origin.frame = CGRect(x: 0, y: self.view.bounds.height * 0.2, width: self.view.bounds.width / 2, height: self.view.bounds.height * 0.2 + 145)
//        origin.route = "400 Daisy Dr., Allen, TX"
//        origin.arival = "11:25 am"
//        origin.type = false
//        origin.startTime = "10:45 am"
//        origin.totalHeight = self.view.bounds.height
        
        let destination = TripDestination()
        destination.frame = CGRect(x: 40, y: self.view.bounds.height * 0.2, width: self.view.bounds.width - 80, height: self.view.bounds.height * 0.25 + 170)
        destination.route = "Ikea, 7171 Ikea Dr., Frisco, TX"
        destination.arival = "2:15 pm"
        //destination.type = true
        destination.startTime = "2:55 pm"
        destination.totalHeight = self.view.bounds.height
        
        self.view.addViews(views: [destination])
        
        let description = UITextView()
        description.frame = CGRect(x: 10, y: destination.frame.maxY, width: self.view.bounds.width - 20, height: self.view.bounds.height - (destination.frame.maxY + 70))
        description.text = trip.desc//"Our weekly route to Ikea, where you can get everything you need in a household. Please be ready for pickup on time. Our bus will only wait till scheduled pickup time."
        description.textColor = .black
        description.textAlignment = .justified
        description.font = UIFont.systemFont(ofSize: 20.0)
        description.isEditable = false
        description.sizeToFit()
        self.view.addSubview(description)
    }
    
    func setBottomButton()
    {
        
        buttonView = UIView(frame: CGRect(x: 20, y: self.view.bounds.height - 60, width: self.view.bounds.width - 40, height: 60))
        buttonView.backgroundColor = #colorLiteral(red: 0, green: 0.3921568627, blue: 0.8235294118, alpha: 1)
        buttonView.layer.cornerRadius = 15
        buttonView.gestureRecognizers = [UITapGestureRecognizer(target: self, action:  #selector (self.viewTapped(_:)))]
        let leftLabel = UILabel()
        leftLabel.frame = CGRect(x: 10, y: 0, width: buttonView.bounds.width - 20, height: buttonView.bounds.height / 2)
        leftLabel.font = UIFont.boldSystemFont(ofSize: 25)
        leftLabel.textAlignment = .center
        leftLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        leftLabel.adjustsFontSizeToFitWidth = true
        leftLabel.numberOfLines = 2
        leftLabel.text = ("$\(trip.price!)")
        buttonView.addSubview(leftLabel)
        
        let rightLabel = UILabel()
        rightLabel.frame = CGRect(x: 10, y: buttonView.bounds.height / 2 - 5, width: buttonView.bounds.width - 20, height: buttonView.bounds.height / 2)
        rightLabel.font = UIFont.boldSystemFont(ofSize: 22)
        rightLabel.textAlignment = .center
        rightLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        rightLabel.adjustsFontSizeToFitWidth = true
        rightLabel.text = ("Round Trip")
        buttonView.addSubview(rightLabel)
        self.view.addSubview(buttonView)
        
        
    }
    
    @objc func viewTapped (_ sender : UITapGestureRecognizer)
    {
        print("purchaseWithEbayPressed")
        sender.view?.shake()
        
        webView.frame = CGRect(x: 0, y: view.bounds.height, width: view.bounds.width, height: 0)
        view.addSubview(webView)
        webView.load(URLRequest(url: trip.checkout!))
        UIView.animate(withDuration: 0.3, animations: {
            self.webView.frame = CGRect(x: 0, y: self.view.bounds.height * 0.2, width: self.view.bounds.width, height: self.view.bounds.height -  self.view.bounds.height * 0.2)
            })
       
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

class TripOriginDestination: UIView
{
    var mapView = MapView()
    var route = String()
    var type = Bool() //FALSE = ORIGIN TRUE = DESTINATION
    var startTime = String()
    var arival = String()
    var totalHeight = CGFloat()
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(frame)
        let typeLabel = UILabel()
        typeLabel.frame = CGRect(x: 10, y: 10, width: bounds.width - 20, height: 22)
        typeLabel.font = UIFont.systemFont(ofSize: 20.0)
        typeLabel.textAlignment = .left
        typeLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        typeLabel.adjustsFontSizeToFitWidth = true
        typeLabel.text = "ORIGIN"
        if(type){typeLabel.text = "DESTINATION"}
        addSubview(typeLabel)
        
        let routeLabel = UILabel()
        routeLabel.frame = CGRect(x: 10, y:  typeLabel.frame.maxY, width: bounds.width - 20, height: 25)
        routeLabel.font = UIFont.systemFont(ofSize: 20.0)
        routeLabel.textAlignment = .left
        routeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        routeLabel.adjustsFontSizeToFitWidth = true
        routeLabel.text = route
        addSubview(routeLabel)
        
        //mapView.mapView.frame = CGRect(x: 10, y:  routeLabel.frame.maxY, width: bounds.width - 20, height: bounds.height * 0.2)
        let mapHeight = totalHeight * 0.2
        mapView.frame = CGRect(x: 10, y:  routeLabel.frame.maxY, width: bounds.width - 20, height: mapHeight)
        mapView.mapView.layer.cornerRadius = 10
        addSubview(mapView)
        
        
        let pickup = UILabel()
        pickup.frame = CGRect(x: 10, y:  mapView.frame.maxY + 10, width: bounds.width - 20, height: 22)
        pickup.font = UIFont.systemFont(ofSize: 20.0)
        pickup.textAlignment = .left
        pickup.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        pickup.adjustsFontSizeToFitWidth = true
        pickup.text = "OUTBOUND PICKUP"
        if(type){pickup.text = "INBOUND PICKUP"}
        addSubview(pickup)
        
        let pickupTime = UILabel()
        pickupTime.frame = CGRect(x: 10, y:  pickup.frame.maxY, width: bounds.width - 20, height: 30)
        pickupTime.font = UIFont.systemFont(ofSize: 20.0)
        pickupTime.textAlignment = .left
        pickupTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        pickupTime.adjustsFontSizeToFitWidth = true
        pickupTime.text = startTime
        addSubview(pickupTime)
        
        let arrivalLabel = UILabel()
        arrivalLabel.frame = CGRect(x: 10, y:  pickupTime.frame.maxY, width: bounds.width - 20, height: 22)
        arrivalLabel.font = UIFont.systemFont(ofSize: 20.0)
        arrivalLabel.textAlignment = .left
        arrivalLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        arrivalLabel.adjustsFontSizeToFitWidth = true
        arrivalLabel.text = "ARRIVAL"
        self.addSubview(arrivalLabel)
        
        let arrivalTime = UILabel()
        arrivalTime.frame = CGRect(x: 10, y:  arrivalLabel.frame.maxY, width: bounds.width - 20, height: 22)
        arrivalTime.font = UIFont.systemFont(ofSize: 20.0)
        arrivalTime.textAlignment = .left
        arrivalTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        arrivalTime.adjustsFontSizeToFitWidth = true
        arrivalTime.text = arival
        addSubview(arrivalTime)
    }
    
}
class TripDestination: UIView
{
    var mapView = MapView()
    var route = String()
    var startTime = String()
    var arival = String()
    var totalHeight = CGFloat()
    override init(frame:CGRect) {
        super.init(frame:frame)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print(frame)
        let typeLabel = UILabel()
        typeLabel.frame = CGRect(x: 10, y: 10, width: bounds.width - 20, height: 22)
        typeLabel.font = UIFont.systemFont(ofSize: 20.0)
        typeLabel.textAlignment = .center
        typeLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        typeLabel.adjustsFontSizeToFitWidth = true
        typeLabel.text = "DESTINATION"
        addSubview(typeLabel)
        
        let routeLabel = UILabel()
        routeLabel.frame = CGRect(x: 10, y:  typeLabel.frame.maxY, width: bounds.width - 20, height: 25)
        routeLabel.font = UIFont.systemFont(ofSize: 20.0)
        routeLabel.textAlignment = .center
        routeLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        routeLabel.adjustsFontSizeToFitWidth = true
        routeLabel.text = route
        addSubview(routeLabel)
        
        //mapView.mapView.frame = CGRect(x: 10, y:  routeLabel.frame.maxY, width: bounds.width - 20, height: bounds.height * 0.2)
        let mapHeight = totalHeight * 0.25
        mapView.frame = CGRect(x: 10, y:  routeLabel.frame.maxY, width: bounds.width - 20, height: mapHeight)
        mapView.mapView.layer.cornerRadius = 10
        addSubview(mapView)
        
        
        let pickup = UILabel()
        pickup.frame = CGRect(x: 10, y:  mapView.frame.maxY + 10, width: bounds.width - 20, height: 22)
        pickup.font = UIFont.systemFont(ofSize: 20.0)
        pickup.textAlignment = .center
        pickup.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        pickup.adjustsFontSizeToFitWidth = true
        pickup.text = "INBOUND PICKUP"
        addSubview(pickup)
        
        let pickupTime = UILabel()
        pickupTime.frame = CGRect(x: 10, y:  pickup.frame.maxY, width: bounds.width - 20, height: 30)
        pickupTime.font = UIFont.systemFont(ofSize: 20.0)
        pickupTime.textAlignment = .center
        pickupTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        pickupTime.adjustsFontSizeToFitWidth = true
        pickupTime.text = startTime
        addSubview(pickupTime)
        
        let arrivalLabel = UILabel()
        arrivalLabel.frame = CGRect(x: 10, y:  pickupTime.frame.maxY, width: bounds.width - 20, height: 22)
        arrivalLabel.font = UIFont.systemFont(ofSize: 20.0)
        arrivalLabel.textAlignment = .center
        arrivalLabel.textColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        arrivalLabel.adjustsFontSizeToFitWidth = true
        arrivalLabel.text = "ARRIVAL"
        self.addSubview(arrivalLabel)
        
        let arrivalTime = UILabel()
        arrivalTime.frame = CGRect(x: 10, y:  arrivalLabel.frame.maxY, width: bounds.width - 20, height: 22)
        arrivalTime.font = UIFont.systemFont(ofSize: 20.0)
        arrivalTime.textAlignment = .center
        arrivalTime.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        //tripLabel.shadowColor = .black
        //tripLabel.shadowOffset = CGSize(width: -2, height: 2)
        arrivalTime.adjustsFontSizeToFitWidth = true
        arrivalTime.text = arival
        addSubview(arrivalTime)
    }
    
}
