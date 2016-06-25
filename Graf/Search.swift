//
//  Search.swift
//  Graf
//
//  Created by Mohamed on 6/20/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//


import UIKit
import Firebase



struct User{
    
    var name: String?
    var email: String?
    var profilePhoto: String?
    
    
    
}

class Search: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    
    var usersStruct = [User]()
    
    var serch = [User]()
    
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    
    var userArray: NSMutableArray = []
    var userArrayEmail: NSMutableArray = []
    var userProfilePhoto: UIImage?
    var userProfilePhotoUrl: NSMutableArray = []
    var index: Int?
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photos: NSMutableArray = []
    
    
    //ViewDidLoad func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.hidden = false
        self.tableView.hidden = true
        self.refrechMe()
        
        
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        
    }
    
    func refrechMe() {
        
        let users = rootRef.child("users")
        
        users.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            
            
            let value = snapshot.key
            
            let value2 = snapshot.value
            
            // self.photos.addObject(snapshot["\(value)"].child("images"))
            self.photos.addObject(value2!["images"])
            self.collectionView.reloadData()
            
            self.checkUser(value)
            
            
            
            
            
        })
    }
    
    
    
    func checkUser(value: String){
        
        
        var tempUser = User()
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            
            print(value)
            
            
            let users = self.rootRef.child("users").child(value)
            
            users.observeEventType(.Value, withBlock:  { (snapshot) in
                
                
                
                if (snapshot.value == nil){

                 print("snapshot.value is nil in search VC line 112")
                }else{
                
                    let value = snapshot.value as! NSDictionary
                
                
                tempUser.email = value["useremail"] as? String
                tempUser.name = value["username"] as? String
                tempUser.profilePhoto = value["userProfilePic"] as? String
                
                self.usersStruct.append(tempUser)
                    self.tableView.reloadData()}
            })
            
        })
        
        
        
    }
    
    
    
    
    //TableView setUP
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serch.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("UserCellID", forIndexPath: indexPath)
        
        let temp = self.serch[indexPath.row]
        
        
        let tempPhoto = NSURL.init(string: temp.profilePhoto!)
        let data = NSData(contentsOfURL: tempPhoto!)
        
        cell.imageView?.image = UIImage.init(data: data!)
        
        
        
        
        
        cell.textLabel?.text = temp.name
        cell.detailTextLabel?.text = temp.email
        
        
        cell.accessoryType = UITableViewCellAccessoryType.None
        return cell
    }
    
    
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.tableView.hidden = false
        self.collectionView.hidden = true
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        
        let count = self.serch.count
        for user in usersStruct{
            
            if (user.name == self.searchBar.text!){
                self.serch.append(user)
                self.searchBar.text = nil
                self.searchBar.placeholder = "Search for user"
                self.tableView.reloadData()
            }
            else if (user.email == self.searchBar.text!){
                self.serch.append(user)
                self.searchBar.text = nil
                self.searchBar.placeholder = "Search for user"
                self.tableView.reloadData()
            }
            
        }
        
        if(count == self.serch.count){
            
            self.searchBar.text = nil
            self.searchBar.placeholder = "User not found"
            
            
        }
        
        
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.collectionView.hidden = false
        self.tableView.hidden = true
        
        
        self.addFollow()
        var temp = User()
        
        temp = serch[indexPath.row]
        
        if let passWord = temp.email {
            
            print(passWord)
            
            
            self.rootRef.child("users").child("\(user!.uid)").child("following").childByAutoId().setValue(passWord)
            
            self.addUserFollowing(passWord)
        }
        
    }
    
    func addFollow(){
        
        // var num2: Int
        
        let post2 = rootRef.child("users").child("\(user!.uid)").child("follow")
        
        
        
        post2.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            let value = snapshot.value
            
            let num = (value as! NSString).integerValue
            let num2 = num + 1
            let poste = self.rootRef.child("users").child("\(self.user!.uid)")
            
            
            poste.updateChildValues(["follow" : "\(num2)"])
            
            
        })
        
        
        
    }
    
    
    func addUserFollowing(email: String) {
        
        
        let users = rootRef.child("users")
        
        users.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            
            
            
            //    let key = snapshot.key
            let value = snapshot.value as! NSDictionary
            let value2 = snapshot.key
            
            let test = (value["useremail"]!)
            
            
            if test as! String == email{
                self.addfollowingUsers(value2)
                
                
            }
        })
        
        
        
        
    }
    
    func addfollowingUsers(key: String){
        
        let userEmail = (user!.email)!
        
        
        let e = rootRef.child("users").child(key).child("followingMe").childByAutoId().setValue("\(userEmail)")
        
        
        let post2 = rootRef.child("users").child(key).child("followers")
        
        
        
        post2.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            let value = snapshot.value
            
            let num = (value as! NSString).integerValue
            let num2 = num + 1
            let poste = self.rootRef.child("users").child(key)
            
            
            poste.updateChildValues(["followers" : "\(num2)"])
            
            
        })
        
        
        
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("exploreCellID", forIndexPath: indexPath) as! ExploreCell
        
        
        let temp = self.photos[indexPath.row] as! NSDictionary
        
        
        let value: NSArray = temp.allValues
        
        
        let url = NSURL.init(string: value[0] as! String)
        let data = NSData(contentsOfURL: url!)
        
        
        
        let image = UIImage.init(data: data!)
        
        cell.configureCell(image!)
        
        
        
        
        
        
        
        return cell
        
    }
    
    
    
    
    
    
    
    
}//End of the class