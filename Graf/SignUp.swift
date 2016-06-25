//
//  SignUp.swift
//  Graf
//
//  Created by Mohamed on 6/17/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePicker = UIImagePickerController()
    var selectedPhoto: UIImage!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userNamerTextField: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.selectPhoto(_:)))
        tap.numberOfTapsRequired = 1
        profileImage.addGestureRecognizer(tap)
        
        profileImage.layer.cornerRadius = profileImage.frame.size.height / 3
        profileImage.clipsToBounds = true
        
    }
    

    
    
    func selectPhoto(tap: UITapGestureRecognizer) {
        self.imagePicker.delegate = self
        self.imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            self.imagePicker.sourceType = .Camera
            
        }else{
            self.imagePicker.sourceType = .PhotoLibrary
        }
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    var storageRef: FIRStorageReference{
        return FIRStorage.storage().reference()
        
    }
    
    var fileUrl: String!
    
  
    @IBAction func CreateAccount(sender: AnyObject) {
        
      
        var data = NSData()
         let newImage = self.ResizeImage(self.profileImage.image!,targetSize: CGSizeMake(390, 390.0))
        data = UIImageJPEGRepresentation(newImage, 0.1)!
        
        
        
        FIRAuth.auth()?.createUserWithEmail(emailText.text!, password: passwordText.text!, completion: { (user, error) in
            if let error = error {
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion:nil)
                
                
                
                    
               
                
                return
            }else{
                   let rootRef = FIRDatabase.database().reference()
                
              rootRef.child("users").child("\(user!.uid)").child("username").setValue(self.userNamerTextField.text)
            rootRef.child("users").child("\(user!.uid)").child("useruid").setValue("\(user!.uid)")
               rootRef.child("users").child("\(user!.uid)").child("useremail").setValue(self.emailText.text)

                rootRef.child("users").child("\(user!.uid)").child("follow").setValue("0")
                rootRef.child("users").child("\(user!.uid)").child("post").setValue("0")
                rootRef.child("users").child("\(user!.uid)").child("followers").setValue("0")
                
                
                
                let changeRequest = user?.profileChangeRequest()
                changeRequest?.displayName = self.userNamerTextField.text
                changeRequest?.commitChangesWithCompletion({ (error) in
                    if let error = error {
                        print(error.localizedDescription)
                        
                        
                        
                        
                        return
                    }
                    
                    
                })
                let filePath = "profileImage/\(user!.uid)"
                let metadata =  FIRStorageMetadata()
                metadata.contentType = "image/jpeg"
                
                self.storageRef.child(filePath).putData(data, metadata: metadata, completion: { (metadata, error) in
                    if let error = error{
                        print("\(error.description)")
                        return
                    }
                    self.fileUrl = metadata?.downloadURLs![0].absoluteString
            rootRef.child("users").child("\(user!.uid)").child("userProfilePic").setValue(self.fileUrl)
                    let changeREquestPhoto = user!.profileChangeRequest()
                    changeREquestPhoto.photoURL = NSURL(string: self.fileUrl)
                    changeREquestPhoto.commitChangesWithCompletion({ (error) in
                        if let error = error{
                            print(error.localizedDescription)
                            return
                        }else{
                            print("Profile Updated")
                            
                        }
                    })
                    
                })
                
                
                let alertController = UIAlertController(title: "Welcome", message: "Sign up completed", preferredStyle: .Alert)
                
                
                let OKAction = UIAlertAction(title: "Login", style: .Default) { (action:UIAlertAction!) in
                    
                    let dvc: SignInViewController = (self.storyboard?.instantiateViewControllerWithIdentifier("SignIn"))! as! SignInViewController
                    self.navigationController?.pushViewController(dvc, animated: true)
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion:nil)
                
                
  
                
            }
            
        })
        
    }
  
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        self.selectedPhoto = info[UIImagePickerControllerEditedImage] as? UIImage
        self.profileImage.image = selectedPhoto
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    
}//End of the class
