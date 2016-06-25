//
//  Profile.swift
//  Graf
//
//  Created by Mohamed on 6/18/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

//
import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth


class Profile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var postLabel: UILabel!
    var photos = [Photo]()
    @IBOutlet weak var followerslabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser


    var photoArray = []
    
    
    
    
//    override func viewWillAppear(animated: Bool) {
//        dispatch_async(dispatch_get_main_queue(), {
//            
//            //   self.refrechMe()
//            self.collectionView.reloadData()
//            
//        })
//    }
//    
    
    override func viewDidLoad() {
   //look its over the viewdidLoad
        
        
        dispatch_async(dispatch_get_main_queue(), {
            
            self.collectionView.reloadData()
          
        })
        
        super.viewDidLoad()
        
        navigationController!.navigationBar.barTintColor = UIColor.appColor()
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
  //check chek      ///i think it should go over here
//        dispatch_async(dispatch_get_main_queue(), {
//            
//            self.collectionView.reloadData()
//            
//        })
        
        
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        self.profileImage.layer.cornerRadius = 50
        
        if let user = SignInViewController.dataService.returnUser() {
            usernameLabel.text = user.displayName
            self.navigationItem.title = user.displayName
            emailLabel.text = user.email
            if user.photoURL != nil {
                if let data = NSData(contentsOfURL: user.photoURL!){
                    self.profileImage!.image = UIImage.init(data: data)
                }
            }
            
            
            self.refrechMe()
            
            self.fillLabels()
        }else {
            // No user is signed in
        }
        
        
    }
    
    func refrechMe() {
        
        let user = SignInViewController.dataService.returnUser()
        
        let conditionRed = rootRef.child("users").child("\(user!.uid)").child("images")
        
        conditionRed.observeEventType(.ChildAdded, withBlock:  { (snapshot) in
            
            //  let key = snapshot.key
            let value = snapshot.value as! String
            //            self.photoArray.arrayByAddingObject(value)
            
            self.checkImage(value)
            
            
        })
    }
    
    
    func checkImage(value: String){
        
        
        
        
        
        dispatch_async(dispatch_get_main_queue(), {
            let dvc = Photo(url: value)
            self.photos.append(dvc)
           self.collectionView.reloadData()
            self.checkLength()
            
            
        })
        
    }
    
    
    
    func checkLength() {
        
        
        
        print("this si the lenght of the photos array:")
        print(self.photos.count)
        
        
    }
    
    
    
    
    
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CellID", forIndexPath: indexPath) as! CellCollectionViewCell
        
 
        
        cell.configureCell(self.photos[indexPath.row])
        
        //print the first index it might be nill
        
    
        
        
        
        return cell
    }
    
    
    func fillLabels(){
        
          let user = FIRAuth.auth()?.currentUser
        
        let followCount = rootRef.child("users").child("\(user!.uid)").child("follow")
        
        followCount.observeEventType(.Value, withBlock:  { (snapshot) in

            let value = snapshot.value
    
           
            self.followingLabel.text = value as? String
        })

        
        
        let followersCount = rootRef.child("users").child("\(user!.uid)").child("followers")
        
        followersCount.observeEventType(.Value, withBlock:  { (snapshot) in
            
            let value = snapshot.value
            
            
            self.followerslabel.text = value as? String
        })

        
        let post = rootRef.child("users").child("\(user!.uid)").child("post")
        
        post.observeEventType(.Value, withBlock:  { (snapshot) in
            
            let value = snapshot.value
            
            
            self.postLabel.text = value as! String
        })

        
        
    }
    
    
    
}//End of the class

