//
//  CommentTableViewCell.swift
//  InstaFeed
//
//  Created by Andrei Rybin on 1/14/16.
//  Copyright © 2016 Andrei Rybin. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var comments: UILabel!
    
    var comment:InstagramAPI.Comments? {
        
        didSet{
            guard let setComment = comment else {
                return
            }
            let line = setComment.fromUserName + ": " + setComment.commentText
            let attrString = NSMutableAttributedString(string: line)
            let range = (line as NSString).rangeOfString(setComment.fromUserName)
            attrString.addAttribute(NSForegroundColorAttributeName,
                value: UIColor.blueColor(),
                range: range)
            
            comments.attributedText = attrString
            
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
