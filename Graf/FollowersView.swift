//
//  FollowersView.swift
//  Graf
//
//  Created by Mohamed on 6/24/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
class FollowersView: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var seg: UISegmentedControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    var followingArray = [String]()
    var followersArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let ref = rootRef.child("users").child("\(user!.uid)").child("following")
        
        ref.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            
          
            let value = snapshot.value as! String
           self.followingArray.append(value)
            self.tableView.reloadData()
       
            
            
        })

        
        
        let ref2 = rootRef.child("users").child("\(user!.uid)").child("followingMe")
        
        ref2.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            
            
            let value = snapshot.value as! String
            self.followersArray.append(value)
            self.tableView.reloadData()
            
            
            
        })

    }

    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        if (seg.selectedSegmentIndex == 0){
            let temp = self.followingArray[indexPath.row] as String
            cell.textLabel?.text = temp
        }
        else{
            let temp = self.followersArray[indexPath.row] as String
            cell.textLabel?.text = temp
        }
        
        
        
        
        
        
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (seg.selectedSegmentIndex == 0){
            return self.followingArray.count}
        else{
            return self.followersArray.count
        }
    }
    @IBAction func segAction(sender: AnyObject) {
        self.tableView.reloadData()
        print("seg pressed")
    }
   
    
}//End of the class
