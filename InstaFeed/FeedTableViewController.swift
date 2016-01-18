//
//  FeedTableViewController.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/14/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit

class FeedTableViewController: UITableViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileView  : UIView!
    @IBOutlet weak var userPosts: UILabel!
    @IBOutlet weak var userFollowers: UILabel!
    @IBOutlet weak var userFollowing: UILabel!
    
    var medias:[InstagramAPI.PopularMedia] = []
    
    struct Storyboard {
        static let feedPhotoCell = "PhotoCell"
        static let commentCell = "CommentCell"
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = 400
        tableView.rowHeight = UITableViewAutomaticDimension
        InstagramAPI().fetchMediaData{ (medias: [InstagramAPI.PopularMedia]) -> () in
            self.medias = medias
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.feedPhotoCell, forIndexPath: indexPath)
        
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
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0,0, tableView.frame.size.width, 40))
        footerView.backgroundColor = UIColor.redColor()
        return footerView
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
