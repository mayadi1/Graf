//
//  SingIn.swift
//  Graf
//
//  Created by Mohamed on 6/17/16.
//  Copyright © 2016 Mohamed. All rights reserved.

//
import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth


class SignInViewController: UIViewController {
    
    static let dataService = SignInViewController()
    
    
    func returnUser() -> FIRUser?{
        
        let currentUser: FIRUser? = FIRAuth.auth()!.currentUser!
        
            return currentUser!

    }
        
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {

        super.viewDidLoad()

        
        
        //Gif file
        let filePath = NSBundle.mainBundle().pathForResource("railway", ofType: "gif")
        let gif = NSData(contentsOfFile: filePath!)
        
        let webViewBG = UIWebView(frame: self.view.frame)
        webViewBG.loadData(gif!, MIMEType: "image/gif", textEncodingName: String(), baseURL: NSURL())
        webViewBG.userInteractionEnabled = false;
        
      
        
        self.view.addSubview(webViewBG)

        self.view.sendSubviewToBack(webViewBG)
        
        
    }
    
    
    @IBAction func LogIn(sender: AnyObject) {
        
        FIRAuth.auth()?.signInWithEmail(emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                
                
                let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                
                
                let OKAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
                    
                }
                alertController.addAction(OKAction)
                
                self.presentViewController(alertController, animated: true, completion:nil)
                
                
                
                return
            }else{
                let dvc: TapBarController = (self.storyboard?.instantiateViewControllerWithIdentifier("TapBar"))! as! TapBarController
                self.navigationController?.pushViewController(dvc, animated: true)
                 if let user = FIRAuth.auth()?.currentUser {
                  
                   
                    
                } else {
                    // No user is signed in.
                }
                
                
                
            }
            
            
        }
        
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
    
}//end of the Class

