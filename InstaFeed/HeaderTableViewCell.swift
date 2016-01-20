//
//  HeaderTableViewCell.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/14/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit
import DateTools

protocol HeaderTableViewCellDelegate {
    func cellTapped(cell: HeaderTableViewCell)
}

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headPostTime: UILabel!
    @IBOutlet weak var headUserName: UILabel!
    @IBOutlet weak var headPic: UIImageView!
    
    var instanceDate: NSDate = NSDate()
    var delegate: HeaderTableViewCellDelegate?
    
    var header: InstagramAPI.PopularMedia? {
        didSet{ //observer
            if let setHeader = header {
                
                self.headUserName.text = setHeader.userName
                self.headUserName.textColor = UIColor(
                    colorLiteralRed: 20.0/255.0,
                    green: 85.0/255.0,
                    blue:  135.0/255.0,
                    alpha: 1.0)
                
                let timeInterval = Double(setHeader.timeStamp)
                let date = NSDate(timeIntervalSince1970: timeInterval)
                let stringTime = instanceDate.shortTimeAgoSinceDate(date)
                self.headPostTime.text = stringTime!
                
                self.headPic.setImageWithURL(NSURL(string: setHeader.profilePicture)!)
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //add gesture recognizers for when a user clicks on a userpicture or the name
        let tapRecognizerOnPic = UITapGestureRecognizer(target: self, action: "onTap") //last parameter is the name of the method
        let tapRecognizerOnName = UITapGestureRecognizer(target: self, action: "onTap")
        //add the listeners
        headPic.addGestureRecognizer(tapRecognizerOnPic)
        headUserName.addGestureRecognizer(tapRecognizerOnName)
    }
    
    func onTap() {
        delegate?.cellTapped(self)
    }
    
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
