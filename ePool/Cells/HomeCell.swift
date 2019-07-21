//
//  HomeCell.swift
//  ePool
//
//  Created by Jonathan Kopp on 7/20/19.
//  Copyright © 2019 Jonathan Kopp. All rights reserved.
//
import UIKit
import Foundation
class HomeCell: UITableViewCell{
    
    var backImage = UIImageView()
    var tripLabel = UILabel()
    var dateLabel = UILabel()
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 5
            frame.size.height -= 20
            frame.size.width -= 40
            frame.origin.x += 20
            super.frame = frame
        }
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.frame.height / 4
        backgroundColor = .clear
        
        backImage.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        backImage.layer.cornerRadius = self.frame.height * 0.05
        backImage.layer.masksToBounds = true
        backImage.clipsToBounds = true
        backImage.contentMode = .scaleAspectFill
        backImage.alpha = 0.9
        addSubview(backImage)
        
        tripLabel.frame = CGRect(x: 65, y: frame.height - 50, width: frame.width - 65, height: 50)
        tripLabel.font = UIFont.boldSystemFont(ofSize: 25)
        tripLabel.textAlignment = .left
        tripLabel.textColor = .white
        tripLabel.shadowColor = .black
        tripLabel.shadowOffset = CGSize(width: -1, height: 1)
        tripLabel.adjustsFontSizeToFitWidth = true
        addSubview(tripLabel)
        
        dateLabel.frame = CGRect(x: 15, y: frame.height - 60, width: 40, height: 50)
        dateLabel.numberOfLines = 2
        dateLabel.font = UIFont.systemFont(ofSize: 20.0)
        dateLabel.textAlignment = .left
        dateLabel.textColor = .white
        dateLabel.shadowColor = .black
        dateLabel.shadowOffset = CGSize(width: -1, height: 1)
        dateLabel.adjustsFontSizeToFitWidth = true
        addSubview(dateLabel)
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

