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
        
        
    }
    override func viewWillLayoutSubviews() {

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let imageView = UIImageView()
        imageView.frame = view.frame
        imageView.contentMode = .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "profile")
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        
        self.view.addSubview(imageView)
    }
}
