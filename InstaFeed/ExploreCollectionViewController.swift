//
//  ExploreCollectionViewController.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/13/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit

class ExploreCollectionViewController: UICollectionViewController {
    
    let leftAndRightPaddings: CGFloat = 32.0
    let numberOfItemsPerRow: CGFloat = 3.0
    let heightAdjustment: CGFloat = 30.0
    
    struct Storyboard {
        static let explorePhotoCell = "ExplorePhotoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set the color for the back ground on load

        self.collectionView?.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        //configure the view
        let width = (CGRectGetWidth(collectionView!.frame) - leftAndRightPaddings) / numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, width + heightAdjustment)
        
        
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //only one section
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of items
        return 6
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.explorePhotoCell, forIndexPath: indexPath) as! ExplorePhotoCollectionViewCell
    
        // Configure the cell
        cell.imageView.image = UIImage(named: "no_image")
        
    
        return cell
    }
}
