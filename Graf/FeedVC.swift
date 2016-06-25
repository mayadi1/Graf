//
//  FeedVC.swift
//
//
//  Created by Mohamed on 6/22/16.
//
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import AVFoundation
import AssetsLibrary
import CoreLocation
import MapKit

struct userInfo{
    
    var name: String?
  
    var profilePhoto: String?
}


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userFollowing = [Photo]()
    
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    var usersStruct = [userInfo]()
    
    var userPhotos = [NSDictionary]()
    var userComments = [NSDictionary]()
    var usersUID = [String]()
    
    //ViewDidLoad func
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController!.navigationBar.barTintColor = UIColor.appColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
   

        
        let conditionRed = rootRef.child("users").child("\(user!.uid)").child("following")
        
        conditionRed.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            
            //  let key = snapshot.key
            let value = snapshot.value as! String
            //            self.photoArray.arrayByAddingObject(value)
            
            self.check(value)
            
            
            
        })
        
        
        
        
        
        
        
        
    }//End of the viewDidLoad func
    
    
    func check(value: String){
        
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
            let dvc = Photo(url: value)
            self.userFollowing.append(dvc)
            
            
            
            
            self.getUSerUid(value)
            self.tableView.reloadData()
            
            
        })
        
    }
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
  
        
    
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedCellID", forIndexPath: indexPath) as! FeedCell
 
        
        let temp = usersStruct[indexPath.row]
        
        
      //  let dic = self.userPhotos[indexPath.row]
        
        
        let dic = self.userPhotos[indexPath.row]
        let dic22 = self.userComments[indexPath.row]
      
        print("this is all keys check ")

        cell.configureCell(temp, dic: dic, dic2: dic22)
        

        //    cell.configureCell(temp, dic: n)

        return cell
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userPhotos.count
    }
    
    
    
    
    
    
    //    func checkUser(value: String){
    //
    //
    //        var tempUser = userInfo()
    //
    //
    //        dispatch_async(dispatch_get_main_queue(), {
    //
    //
    //            print(value)
    //
    //
    //            let users = self.rootRef.child("users").child(value)
    //
    //            users.observeEventType(.Value, withBlock:  { (snapshot) in
    //
    //
    //
    //
    //                let value = snapshot.value as! NSDictionary
    //
    //
    //
    //                tempUser.email = value["useremail"] as? String
    //                tempUser.name = value["username"] as? String
    //                tempUser.profilePhoto = value["userProfilePic"] as? String
    //
    //                self.usersStruct.append(tempUser)
    //                self.tableView.reloadData()
    //            })
    //
    //        })
    //
    //
    //
    //    }
    
    
    func getUSerUid(email: String) {
        var info = userInfo()
        
        
        let users = rootRef.child("users")
        
        users.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            
            self.tableView.reloadData()
            
            
        //    let key = snapshot.key
            let value = snapshot.value as! NSDictionary
            let n = snapshot.key
            
          let test = (value["useremail"]!)
       
            
            if test as! String == email{
                
                
                
                let usersb = self.rootRef.child("users").child("\(n)").child("images")
                
                usersb.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
                    
                    let dictionary = ["f": "\(snapshot.value!)"]
                    //add the table view the new image
                    
            
                    self.userPhotos.insert(dictionary, atIndex: 0)
                    
                    info.name = (value["username"]!) as? String
                    
                    info.profilePhoto = (value["userProfilePic"]!) as? String
                
                    
                    self.usersStruct.append(info)
                    self.tableView.reloadData()
                })
                
                // see if any Description added
                let usersbn = self.rootRef.child("users").child("\(n)").child("Description")
                
                usersbn.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
                    
                    let dictionary = ["f": "\(snapshot.value!)"]
                    //add the table view the new image
                    
                    
                    self.userComments.insert(dictionary, atIndex: 0)
//                    
//                    info.name = (value["username"]!) as? String
//                    
//                    info.profilePhoto = (value["userProfilePic"]!) as? String
//                    
//                    
//                    self.usersStruct.append(info)
//                    self.tableView.reloadData()
                })
                

                
                
                print("this is th value")
                print(test)
                info.name = (value["username"]!) as? String
                
                info.profilePhoto = (value["userProfilePic"]!) as? String
                
        
                
                self.userPhotos.append(value["images"] as! NSDictionary)
                
                self.userComments.append(value["Description"] as! NSDictionary)

                
                self.usersStruct.append(info)
                self.tableView.reloadData()
                
                
            }
            })
            
            
            
      
    }
    
    
    
    
    
    
    
}
