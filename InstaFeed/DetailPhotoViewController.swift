//
//  DetailPhotoViewController.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/16/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit

class DetailPhotoViewController: UIViewController {

    var photo: NSDictionary?
    var imageView: UIImageView?
    var animator: UIDynamicAnimator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(white: 1.0, alpha: 0.9)
        //set a rect to display the image in, 320 on y axis away from the top left corner
        self.imageView = UIImageView(frame: CGRectMake(0, -320, self.view.bounds.size.width, self.view.bounds.size.width))
        self.view.addSubview(imageView!)
        
        if let _ = photo { //photoDictionary
            InstagramData.imageForPhoto(photo!, size: ImageSizes.STANDARD_RESOLUTION.rawValue, completion: { (image, _) -> Void in
                self.imageView!.image = image
            })
        }
        
        let tap = UITapGestureRecognizer(target: self, action: "close") //close if user tries to navigate away by tapping on the picture
        self.view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        animator = UIDynamicAnimator(referenceView: self.view)
        let snap = UISnapBehavior(item: self.imageView!, snapToPoint: self.view.center)
        self.animator?.addBehavior(snap)
    }
    
    func close() { //close refered to on UITapGestureRecognizer
        self.animator?.removeAllBehaviors()
        
        let snap = UISnapBehavior(item: self.imageView!, snapToPoint:
            CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMaxY(self.view.bounds)+180))
        self.animator?.addBehavior(snap)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
