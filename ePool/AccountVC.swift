//
//  AccountVC.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/21/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//

import Foundation
import UIKit

class AccountVC: UIViewController
{
    override func viewDidAppear(_ animated: Bool) {
        let bottom = navigationController?.navigationBar.frame.maxY
        let top = self.view.safeAreaInsets.top
        
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: bottom!, width: self.view.bounds.width, height: self.view.bounds.height - (bottom! + top))
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "profile")
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        self.view.addSubview(imageView)
    }
    override func viewWillLayoutSubviews() {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Account"
        
    }
}
