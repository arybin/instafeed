//
//  InstagramAPI.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/18/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import Foundation
import Alamofire //for networking
import SwiftyJSON

class InstagramAPI {
    //https://api.instagram.com/v1/tags/nofilter/media/recent?access_token=ACCESS_TOKEN

    //https://api.instagram.com/v1/users/self/media/recent/?access_token=ACCESS-TOKEN
    
    //https://api.instagram.com/v1/users/{user-id}/media/recent/?access_token=ACCESS-TOKEN
    
    let access_token = "249641847.50e7b46.7d8859b864a440e78604b61a1819efab"
    
    
    //popular media struct containing all info we can get from instagram's api
    struct PopularMedia {
        let takenPhoto: String
        let userId: String
        let userName: String
        let profilePicture: String
        let caption:String
        let comments: [Comments]
        let likesCount: Int
        let timeStamp: Int
    }
    
    struct Comments {
        let fromUserName: String
        let commentText: String
    }
    
    struct User {
        let posts: Int
        let followers: Int
        let follows: Int
    }
    
    //fetch popular media data
    
    func fetchMediaData(callback: ([PopularMedia]) -> Void) {
        //make a request
        request(.GET, "https://api.instagram.com/v1/tags/nofilter/media/recent?access_token=\(self.access_token)").responseJSON { (response) -> Void in
            print(response.description)
            self.populateMedia(response.result.value!, callback: callback)
            
        }
    }
    //method to populate popular media struct
    func populateMedia(data: AnyObject?, callback: ([PopularMedia])-> Void) {
        let json = JSON(data!)
        
        var medias = [PopularMedia]()
        
        for item in json["data"].arrayValue {
            //get comments first data/comments
            var comments = [Comments]()
            
            for comment in item["comments"]["data"].arrayValue {
                comments.append(Comments(fromUserName: comment["from"]["username"].stringValue ,
                    commentText:comment["text"].stringValue))
            }
            
            medias.append(PopularMedia(
                takenPhoto: item["images"][ImageSizes.STANDARD_RESOLUTION.rawValue]["url"].stringValue,
                userId: item["user"]["id"].stringValue,
                userName: item["user"]["username"].stringValue,
                profilePicture: item["user"]["profile_picture"].stringValue,
                caption: item["caption"]["text"].stringValue,
                comments: comments,
                likesCount: item["likes"]["count"].intValue,
                timeStamp: item["created_time"].intValue)
            )
        }
        callback(medias)
    }
    
    //fetch user profile data
    func fetchUserData(id: String, callback: (User) -> Void) {
        request(.GET, "https://api.instagram.com/v1/users/\(id)/?access_token=\(self.access_token)")
            .responseJSON { (response) -> Void in
            print(response)
            self.populateUserInfo(response.result.value!, callback: callback)
        }
        
    }
    
    func populateUserInfo(data: AnyObject?, callback: (User) -> Void) {
        let json = JSON(data!)
        
        callback(User(
            posts: json["data"]["counts"]["media"].intValue,
            followers: json["data"]["counts"]["followed_by"].intValue ,
            follows: json["data"]["counts"]["followers"].intValue
        ))
    }
    
    //fetch user's posts
    func fetchUsersRecentMediaPosts(id: String, callback: ([PopularMedia]) -> Void) {
        request(.GET, "https://api.instagram.com/v1/users/\(id)/media/recent/?access_token=\(self.access_token)")
            .responseJSON { (response) -> Void in
                print(response)
                self.populateMedia(response.result.value!, callback: callback)
                
        }
    }

}
