//
//  PhotoTableViewCell.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/14/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var info: UILabel!
    
    
    var media: InstagramAPI.PopularMedia? {
        didSet{
            if let setMedia = media {
                info.text = setMedia.caption
                likes.text = String(setMedia.likesCount)
                if let url = NSURL(string: setMedia.takenPhoto) {
                    photo.setImageWithURL(url)
                }
                
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
