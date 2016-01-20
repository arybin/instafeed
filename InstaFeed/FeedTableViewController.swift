//
//  FeedTableViewController.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/14/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController, HeaderTableViewCellDelegate {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileView  : UIView!
    @IBOutlet weak var userPosts: UILabel!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    
    var medias:[InstagramAPI.PopularMedia] = []
    var userId = "1"
    var profilePicture = ""
    var flag = false //indicate if the header view is shown
    
    struct Storyboard {
        static let feedPhotoCell = "PhotoCell"
        static let commentCell = "CommentCell"
        static let HeaderCellFeedTable = "HeaderCellFeedTable"
    }
    
    //refresh data
    
    func refresh() {
        
        if flag  == true {
            updateData()
        } else {
            //updating your data here
            InstagramAPI().fetchMediaData{ (medias: [InstagramAPI.PopularMedia]) -> () in
                self.medias = medias
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toggleHeader()
        //register xib
        self.tableView.registerNib(
            UINib(nibName: "HeaderTableViewCell", bundle: nil),
            forCellReuseIdentifier: Storyboard.HeaderCellFeedTable
        )
        
        tableView.estimatedRowHeight = 450
        tableView.rowHeight = UITableViewAutomaticDimension
        //round the image
        self.userImage.layer.borderWidth = 1
        self.userImage.layer.masksToBounds = false
        self.userImage.layer.borderColor = UIColor.blackColor().CGColor
        self.userImage.layer.cornerRadius = self.userImage.frame.height / 2
        self.userImage.clipsToBounds = true
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView!.addSubview(refreshControl!)
        
        refresh()
       
    }
    
    //Update user profile page section
    func updateData() {
        //going to update in the background
        dispatch_async(dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)) { () -> Void in
            //need method to update user data
            InstagramAPI().fetchUserData(self.userId, callback: { userProfile in
                
                let font = UIFont(name: "AvenirNext-Regular", size: 14)
                
                self.userFollowers.text = "Followers; " + String(userProfile.followers)
                self.userFollowers.font = font
                
                self.userFollowing.text = "Following: " + String(userProfile.follows)
                self.userFollowing.font = font
                
                self.userPosts.text = "Posts: " + String(userProfile.posts)
                self.userPosts.font = font
                
                if let url = NSURL(string: self.profilePicture),
                    data = NSData(contentsOfURL: url),
                    photo = UIImage(data: data) {
                        self.userImage.image = photo
                } else {
                    self.userImage.image = UIImage(named: "no_image")
                }
                //update the profile page
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    InstagramAPI().fetchUsersRecentMediaPosts(self.userId, callback: { (medias: [InstagramAPI.PopularMedia]) -> Void in
                        self.medias = medias
                        self.tableView.reloadData()
                    })
                })
            })
        }
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return medias.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return medias[section].comments.count + 1 //to push down
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //cell
        let _ = tableView.dequeueReusableCellWithIdentifier(Storyboard.feedPhotoCell, forIndexPath: indexPath)
        
        //first cell is for media
        if(indexPath.row == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.feedPhotoCell, forIndexPath: indexPath) as! PhotoTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None //don't highlight the cell
            cell.media = self.medias[indexPath.section]
            return cell

        } else { //it's a comments row
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.commentCell, forIndexPath: indexPath) as! CommentTableViewCell
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            cell.selectionStyle = UITableViewCellSelectionStyle.None //don't highlight the cell
            let currentMedia = self.medias[indexPath.section].comments[indexPath.row - 1]
            cell.comment = currentMedia
            return cell
        }        
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0 //just manually for now to make it look nice
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.HeaderCellFeedTable) as! HeaderTableViewCell
        
        var frame = cell.frame
        frame.size.height = 100
        cell.frame = frame
//        cell.backgroundColor = UIColor.grayColor()
        cell.header = medias[section]
        cell.delegate = self
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0,0, tableView.frame.size.width, 40))
        footerView.backgroundColor = UIColor.whiteColor()
        return footerView
    }

    //Did tap
    
    func cellTapped(cell: HeaderTableViewCell) {
        let tappedUser = cell.header
        let id = tappedUser?.userId
        let storyBoard = UIStoryboard(name:  "Main", bundle: nil)
        let controller = storyBoard.instantiateViewControllerWithIdentifier("Feed") as! FeedTableViewController
        controller.flag = true
        controller.userId = id!
        controller.profilePicture = (tappedUser?.profilePicture)!
        controller.title = tappedUser?.userName
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func toggleHeader() {
        tableView.tableHeaderView = flag ? self.profileView : nil
        
    }

}
