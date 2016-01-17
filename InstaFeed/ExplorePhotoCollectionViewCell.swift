//
//  ExplorePhotoCollectionViewCell.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/13/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit

class ExplorePhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var likesCount: UILabel!
    
    var photo: AnyObject! {
        didSet{
            InstagramData.imageForPhoto(photo, size: ImageSizes.THUMBNAIL.rawValue) { (image, likeCount) -> Void in
                self.imageView.image = image
                self.likesCount.text = "💗 " + String(likeCount) + " likes"
            }
        }
    }
    
}
