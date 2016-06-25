//
//  FeedCell.swift
//  Graf
//
//  Created by Mohamed on 6/22/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Foundation




class FeedCell: UITableViewCell {
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var friendPhoto: UIImageView!
    
    @IBOutlet weak var likesCountLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UITextView!
    
    var like = 0
    var info = userInfo()
    
    
    
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        
        
      
        
        
        
        like = like + 1 
        likesCountLabel.text = ("\(like)")
        
    }
    
    @IBAction func commentButtonPressed(sender: AnyObject) {
    }
    
    
    
    
    func configureCell(user: userInfo, dic: NSDictionary, dic2: NSDictionary) {

        let comment: NSArray = dic2.allValues
        
        let value: NSArray = dic.allValues
        
        let url = NSURL.init(string: user.profilePhoto!)
        let data = NSData(contentsOfURL: url!)
        
        
        self.profileImage.layer.cornerRadius = 31
 

        
        
        self.descriptionLabel.text = comment[0] as? String
        self.descriptionLabel.resolveHashTags()
        self.profileImage.image = UIImage.init(data: data!)
        
               
        self.usernameLabel.text = user.name
        
        

        
       
        
            let url2 = NSURL.init(string: value[0] as! String)
            let data2 = NSData(contentsOfURL: url2!)
      
        if data2 != nil {
            self.friendPhoto.image = UIImage.init(data: data2!)
            self.friendPhoto.transform  = CGAffineTransformMakeRotation(CGFloat(M_PI_2));

        }
        
        
    }
    
    
    
    
    
}//End of the class




