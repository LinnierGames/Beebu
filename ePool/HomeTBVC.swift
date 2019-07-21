//
//  HomeTBVC.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class HomeTBVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var hasAnimated = Bool()
    var tableView = UITableView()
    var trips = [Trip]()
    let ebayService = eBayService()
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottom = self.view.safeAreaInsets.bottom
        tableView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - (55 + bottom))
        
    }
    override func viewWillLayoutSubviews() {
        
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Allen, TX"
        
        print("TableView Loaded")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
        
        navigationController?.navigationBar.gestureRecognizers = [UITapGestureRecognizer(target: self, action:  #selector (self.profileClicked))]
    }
    override func viewDidAppear(_ animated: Bool) {
        loadData()
        
        //self.tableView.reloadData()
    }

    @objc func profileClicked()
    {
        print("Profile Pressed")
        let vc = ViewController()
        self.navigationController?.present(vc, animated: false, completion: nil)
//
        vc.pressSignIn(self)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TripDetailView()
        vc.trip = self.trips[indexPath.row]
        let animation = CATransition()
        animation.type = .push
        animation.subtype = .fromTop
        animation.duration = 0.3
        self.view.window!.layer.add(animation, forKey: nil)
        navigationController?.present(vc, animated: false, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height * 0.25
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeCell()
        cell.selectionStyle = .none
        if let imgURL = trips[indexPath.row].backImageUrl
        {
            cell.backImage.downloaded(from: imgURL)
        }else{
            cell.backImage.image = trips[indexPath.row].backImage!
        }
        
        cell.tripLabel.text = trips[indexPath.row].name!
        cell.dateLabel.text = trips[indexPath.row].date!
        return cell
    }
    override func viewDidDisappear(_ animated: Bool) {
        trips = [Trip]()
        tableView.reloadData()
    }
    func loadData()
    {
        hasAnimated = false
        ebayService.listListings { listing in
            print(listing)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM"
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "d"
            for item in listing
            {
                var trip = Trip()
                trip.name = item.title
                let month = dateFormatter.string(from: item.date)
                let day = dateFormatter2.string(from: item.date)
                trip.date = ("\(month)\n\(day)")
                trip.backImage = #imageLiteral(resourceName: "IMG_2984")
                trip.price = item.price
                trip.desc = item.description
                trip.checkout = item.storeUrl
                if let url = item.thumbnail
                {
                    trip.backImageUrl = url
                }
                self.trips.append(trip)
            }
            self.tableView.reloadData()
        }
        //
    }
//    func dummyData()
//    {
//        var trip = Trip()
//        trip.name = "Parker Road DIART"
//        trip.date = "JUL\n22"
//        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
//        trips.append(trip)
//
//        trip = Trip()
//        trip.name = "Ikea at Frisco"
//        trip.date = "JUL\n22"
//        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
//        trips.append(trip)
//
//        trip = Trip()
//        trip.name = "Parker Road DIART"
//        trip.date = "JUL\n23"
//        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
//        trips.append(trip)
//
//        trip = Trip()
//        trip.name = "Sprouts Farmers Market"
//        trip.date = "JUL\n23"
//        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
//        trips.append(trip)
//    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! HomeCell
        if(hasAnimated){return}
        cell.transform = CGAffineTransform(translationX: tableView.bounds.width, y: 0)
        cell.backImage.alpha = 0.2
        UIView.animate(
            withDuration: 0.5,
            delay: 0.1 * Double(indexPath.row),
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.backImage.alpha = 0.8
        })
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row == trips.count - 1)
        {
            hasAnimated = true
        }
    }
    
}

struct Trip
{
    var name: String?
    var date: String?
    var backImage: UIImage?
    var backImageUrl: URL?
    var price: Double?
    var desc: String?
    var checkout: URL?
}
