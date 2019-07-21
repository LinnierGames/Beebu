//
//  TabBar.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UIViewController
{
    var buttonContainer = UIView()
    var homeButton = tabBarButton()
    var myRidesButton = tabBarButton()
    var profileButton = tabBarButton()
    var prevButton: tabBarButton?
    var prevVC: UIViewController?
    var viewControllerStrings = [String]()
    var viewControllers = [UIViewController]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
         let bottom = self.view.safeAreaInsets.bottom
        buttonContainer.frame = CGRect(x: 0, y: self.view.bounds.height - (55 + bottom), width: self.view.bounds.width, height: (55 + bottom))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Tab Bar was loaded")
        let storyboard = UIStoryboard(name: "MyRidesViewController", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MyRidesViewController")
        
        viewControllerStrings = ["Home","MyRides","Account"]
        viewControllers = [UINavigationController(rootViewController: HomeTBVC()),UINavigationController(rootViewController: controller),UINavigationController(rootViewController: HomeTBVC())]
        
        buttonContainer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.8)
        buttonContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        buttonContainer.layer.cornerRadius = 20
        //Middle Buttons
        myRidesButton.frame = CGRect(x: (self.view.bounds.width / 2 - 20), y: 5, width: 35, height: 35)
        myRidesButton.setImage(#imageLiteral(resourceName: "icons8-ticket-48"), for: .normal)
        myRidesButton.tag = 1
        myRidesButton.tntColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        myRidesButton.maskColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        myRidesButton.maskImage = #imageLiteral(resourceName: "icons8-ticket-48 (1)")
        myRidesButton.title = "Rides"
        myRidesButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        //Side Buttons
        homeButton.frame = CGRect(x: (self.view.bounds.width / 2) - 115, y: 5, width: 35, height: 35)
        profileButton.frame = CGRect(x: (self.view.bounds.width / 2) + 75, y: 5, width: 35, height: 35)
        homeButton.setImage(#imageLiteral(resourceName: "icons8-bus-50"), for: .normal)
        homeButton.tag = 0
        homeButton.tntColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        homeButton.maskColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        homeButton.maskImage = #imageLiteral(resourceName: "icons8-bus-50 (1)")
        homeButton.title = "Routes"
        homeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        profileButton.setImage(#imageLiteral(resourceName: "icons8-male-user-50"), for: .normal)
        profileButton.tag = 2
        profileButton.tntColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileButton.maskColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        profileButton.maskImage = #imageLiteral(resourceName: "icons8-male-user-50 (1)")
        profileButton.title = "Profile"
        profileButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        self.buttonContainer.addViews(views: [myRidesButton,homeButton,profileButton])
        self.view.addSubview(buttonContainer)
        buttonPressed(homeButton)
    }
    
    @objc func buttonPressed(_ sender: tabBarButton)
    {
        if let b = prevButton
        {
            b.stopAnimation()
        }
        print(viewControllerStrings[sender.tag])
        sender.beginAnimation()
        let vc = viewControllers[sender.tag]
        if let previousVC = prevVC
        {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
        addChild(vc)
        vc.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        
        self.view.addSubview(vc.view)
        self.view.sendSubviewToBack(vc.view)
        
        vc.view.bringSubviewToFront(self.view)
        prevVC = viewControllers[sender.tag]
        prevButton = sender
    }
    
}



class tabBarButton: UIButton
{
    var title = String()
    var tntColor = UIColor()
    var maskColor = UIColor()
    var maskImage = UIImage()
    var oldImage = UIImage()
    var label = UILabel()
    
    
    func beginAnimation()
    {
        

        label.text = title
        label.frame = CGRect(x: 0, y: self.frame.maxY - 5.5, width: 35, height: 15)
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = tntColor
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        
        UIView.animate(withDuration: 0.2, animations: {
            self.oldImage = ((self.imageView?.image!)!)
            self.setImage(self.maskImage.mask(with: self.maskColor), for: .normal)
            self.addSubview(self.label)
        })
    }
    
    func stopAnimation()
    {
        UIView.animate(withDuration: 0.2, animations: {
        }, completion: { (finished: Bool) in
            self.setImage(self.oldImage, for: .normal)
            self.label.removeFromSuperview()
        })
    }
}
