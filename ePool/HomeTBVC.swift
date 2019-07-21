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
       
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        button.backgroundColor = .clear
        button.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        button.setTitle("Allen, TX", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 22.0)
        button.addTarget(self, action: #selector(profileClicked), for: .touchUpInside)
        navigationItem.titleView = button
        
        print("TableView Loaded")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        self.view.addSubview(tableView)
    }
    override func viewDidAppear(_ animated: Bool) {
        dummyData()
        hasAnimated = false
        self.tableView.reloadData()
    }

    @objc func profileClicked()
    {
        print("Profile Pressed")
//        let vc = ViewController()
       // self.navigationController?.present(, animated: false, completion: nil)
//
//        vc.pressSignIn(self)
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
        cell.backImage.image = trips[indexPath.row].backImage!
        cell.tripLabel.text = trips[indexPath.row].name!
        cell.dateLabel.text = trips[indexPath.row].date!
        return cell
    }
    override func viewDidDisappear(_ animated: Bool) {
        trips = [Trip]()
        tableView.reloadData()
    }
    
    func dummyData()
    {
        var trip = Trip()
        trip.name = "Parker Road DIART"
        trip.date = "JUL\n22"
        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
        trips.append(trip)
        
        trip = Trip()
        trip.name = "Ikea at Frisco"
        trip.date = "JUL\n22"
        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
        trips.append(trip)
        
        trip = Trip()
        trip.name = "Parker Road DIART"
        trip.date = "JUL\n23"
        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
        trips.append(trip)
        
        trip = Trip()
        trip.name = "Sprouts Farmers Market"
        trip.date = "JUL\n23"
        trip.backImage = #imageLiteral(resourceName: "IMG_2984")
        trips.append(trip)
    }
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
}
