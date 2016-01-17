//
//  ExploreCollectionViewController.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/13/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit
import SimpleAuth

class ExploreCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var accessToken: String!
    private var photoDictionaries = [AnyObject]()
    private var data:[[String: String!]] = []
    
    private let ACCESS_TOKEN_STR: String = "accessToken"
    private let leftAndRightPaddings: CGFloat = 32.0
    private let numberOfItemsPerRow: CGFloat = 3.0
    private let heightAdjustment: CGFloat = 30.0
    
    struct Storyboard {
        static let explorePhotoCell = "ExplorePhotoCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configure search bar, by subscribing to its events
        self.navigationItem.titleView = searchBar
        self.searchBar.delegate = self
        
        //set the color for the back ground on load
        
        self.collectionView?.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        //configure the view
        let width = (CGRectGetWidth(collectionView!.frame) - leftAndRightPaddings) / numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSizeMake(width, width + heightAdjustment)
        
        authInstagram()
        
    }
    
    func authInstagram() {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let token = userDefaults.objectForKey(self.ACCESS_TOKEN_STR) as? String {
            
            self.accessToken = token
            print(accessToken)
            
            //start fetching photos
            fetchPhotos()
            
        } else {
            
            SimpleAuth.authorize("instagram") {
                (responseObject, error) -> Void in
                if let resposne = responseObject as? NSDictionary {
                    let credentials = resposne["credentials"] as! NSDictionary
                    let accessToken = credentials["token"] as! String
                    self.accessToken = accessToken
                    
                    userDefaults.setObject(self.accessToken, forKey: self.ACCESS_TOKEN_STR)
                    userDefaults.synchronize()
                    
                    self.fetchPhotos()
                }
            }
        }
    }
    //MARK: Helper Methods
    //https://api.instagram.com/v1/tags/{tag-name}/media/recent?access_token=ACCESS-TOKEN
    func urlWithSearchText(searchText: String) -> NSURL {
        //let espacedSearchText = searchText.stringByReplacingOccurrencesOfString(" ", withString: "") //remove whitespaces
        
        let urlString = "https://api.instagram.com/v1/users/self/media/recent/?access_token=\(self.accessToken)"
        //let urlString = "https://api.instagram.com/v1/tags/\(espacedSearchText)/media/recent?access_token=\(self.accessToken)"
        
        return NSURL(string: urlString)!
    }
    
    func fetchPhotos() {
        //get the session first
        let session = NSURLSession.sharedSession()
        let searchText = self.searchBar.text!
        let url: NSURL
        
        if !searchText.isEmpty {
            url = urlWithSearchText(searchText)
        } else {
            url = urlWithSearchText("car")
        }
        //create a request for fetching from server
        let request = NSURLRequest(URL: url)
        
        let task = session.downloadTaskWithRequest(request) { (localFile, response, error) -> Void in
            if error == nil { //no errors in the request
                let data = NSData(contentsOfURL: localFile!) //received data
                //parse json with NSJSON serializer
                do{
                    let responseDictionary = try NSJSONSerialization.JSONObjectWithData(data! , options: NSJSONReadingOptions.AllowFragments)
                    
                    self.photoDictionaries = responseDictionary.valueForKey("data") as! [AnyObject]
                    
                    for result in self.photoDictionaries {
                        let likes = result.valueForKeyPath("likes.count")!.stringValue
                        let comment = result.valueForKeyPath("comments.count")!.stringValue
                        let obj = ["comments": comment, "likes": likes]
                        self.data.append(obj)
                        
                    }
                    //this feature is not implemented
                    //self.orderByLikes()
                    
                } catch let error{
                    print(error)
                }
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.collectionView?.reloadData()
            })

        }
        task.resume()
    }
    
    func orderedBy(key: String) {
        //sort by likes or comments, needs to be in background threat
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        
        dispatch_async(dispatch_get_global_queue(priority, 0)) { () -> Void in
            //sort in the background
            self.data.sortInPlace {
                item1, item2 in
                let value1 = Double(item1[key]!)
                let value2 = Double(item2[key]!)
                
                return value1 > value2
            }
            
            //foreground thread
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                 self.collectionView?.reloadData()
            })
        }
    }
    
    func orderByLikes() {
        orderedBy("likes")
    }
    
    //MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //only one section
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of items
        return self.photoDictionaries.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(Storyboard.explorePhotoCell, forIndexPath: indexPath) as! ExplorePhotoCollectionViewCell
        
        // Configure the cell
        //cell.imageView.image = UIImage(named: "no_image")
        cell.photo = self.photoDictionaries[indexPath.item]
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //display image taking most of the screen when a user clicks on an image
        let photo = self.photoDictionaries[indexPath.row] as! NSDictionary
        let viewController = DetailPhotoViewController()
        
        //to make a nice animation need to subscribe to the transiction delegate
        viewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        viewController.transitioningDelegate = self
        viewController.photo = photo
        //now show the view
        self.presentViewController(viewController, animated: true, completion: nil)
    }
}

//MARK: - UISearchBarDelegate

extension ExploreCollectionViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            //someoneTypedSomething in there
            searchBar.resignFirstResponder()
            fetchPhotos()
        }
    }
}

//MARK: - CollectionViewTransitionDelegate

extension ExploreCollectionViewController: UIViewControllerTransitioningDelegate {
    
    //responsible for showing the view
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentDetailTransition()
    }
    
    
    //responsible for dismissing the view
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissDetailTransition()
    }
}
