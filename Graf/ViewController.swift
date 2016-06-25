//
//  ViewController.swift
//  Graf
//
//  Created by Mohamed on 6/16/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import Firebase

struct connect {
    var name: String!
    var message: String!
    var image: UIImage?
    
}//End of the connect Struct

class ViewController: UIViewController {
    
    var name: String?
    
    @IBOutlet weak var testLabel: UILabel!
    let rootRef = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.extendTheViewControler()
        }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let conditionRed = rootRef.child("condition")
        
        conditionRed.observeEventType(.Value) { (snap: FIRDataSnapshot) in
        
            
            self.testLabel.text = snap.value?.description

    }
        
        let dictionary = ["Table": "Good surface"]
        
        rootRef.child("users").setValue(dictionary)
        
        
        
        rootRef.child("users").child("Jon").child("Habits").setValue(["Hygiene":"Great","Spelling":"Good"])
        
        let usersRef = rootRef.child("users")
        
        let array = ["Generally", "Can't sleep well usually", 4, 0.5, ["Hygiene":"Great","Spelling":"Good"]]
        
        usersRef.child("Jon").child("Habits").setValue(array)
        
        
        
        
        


    }//End of ViewDidLoad func

    
 

}//End of the Class

