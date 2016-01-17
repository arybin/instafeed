//
//  InstagramData.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/16/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit
import SAMCache

//this file is a model responsible for parsing out the dictionary with pictures

class InstagramData {
    
    static func imageForPhoto(photoDict: AnyObject, size: String, completion: (image: UIImage, likesCount: Int) -> Void) {
        
        let photoId = photoDict.valueForKeyPath("id") as! String
        let likesCount = photoDict.valueForKeyPath("likes.count") as! Int
        
        let key = "\(photoId)-\(size)" //id-thumbnail
        //check if image is already stored inside of the device
        if let image = SAMCache.sharedCache().imageForKey (key) {
            completion(image: image, likesCount: likesCount)
        } else {
            
            let urlString = photoDict.valueForKeyPath("images.\(size).url") as! String //url to the image depending on the requested size
            
            let url  = NSURL(string: urlString)!
            
            let session = NSURLSession.sharedSession()
            let request = NSURLRequest(URL: url)
            
            
            let task = session.downloadTaskWithRequest(request) { (localFile, response, error) -> Void in
                if error == nil {
                    let data = NSData(contentsOfURL: localFile!)
                    let image = UIImage(data: data!)
                    //else put it in the shared storage
                    SAMCache.sharedCache().setImage(image, forKey: key)
                    //request to run this in async
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        completion(image: image!, likesCount: likesCount)
                    })
                    
                }
            }
            
            task.resume()
        }
        
    }
    
    
}
