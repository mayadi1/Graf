//
//  FilterViewController.swift
//  Graf
//
//  Created by Christopher Benavides on 6/21/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth


class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var filterPicker: UIPickerView!
    @IBOutlet var textView: UITextView!
    var image: UIImage?
    var filterTitleList: [String]!
    var filterNameList: [String]!
    var transform = CGAffineTransformIdentity
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.image = self.image
        self.filterTitleList = ["(( Choose Filter ))" ,"Chrome", "Fade", "Instant", "Mono", "Noir", "Process", "Tonal", "Transfer"]
        self.filterNameList = ["No Filter" ,"CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]
        self.filterPicker.delegate = self
        self.filterPicker.dataSource = self
        self.filterPicker.userInteractionEnabled = true
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        self.textView.resolveHashTags()
        let newText = (textView.text as NSString).stringByReplacingCharactersInRange(range, withString: text)
        let numberOfChars = newText.characters.count
        return numberOfChars < 120;
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        if let newImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.image = newImage
            self.imageView.image = self.image
            self.filterPicker.userInteractionEnabled = true
            self.filterPicker.selectRow(0, inComponent: 0, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.filterTitleList.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.filterTitleList[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.applyFilter(selectedFilterIndex: row)
        // self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        // self.imageView.clipsToBounds = true
        //MyImageview.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    
    private func applyFilter(selectedFilterIndex filterIndex: Int) {
        
        
        
        if filterIndex == 0 {
            self.imageView.image = self.image
            return
        }
        
        let sourceImage = CIImage(image: self.imageView.image!)
        
        let myFilter = CIFilter(name: self.filterNameList[filterIndex])
        //  myFilter?.setDefaults()
        
        //        myFilter?.setValue(sourceImage, forKey: kCIInputImageKey)
        //        myFilter?.setValue(0.5, forKey: "inputScale")
        //        myFilter?.setValue(1.0, forKey: "inputAspectRatio")
        
        myFilter!.setValue(sourceImage, forKey: "inputImage")
        //        myFilter!.setValue(0.5, forKey: "inputScale")
        //        myFilter!.setValue(1.0, forKey: "inputAspectRatio")
        
        let context = CIContext(options: nil)
        
        let outputCGImage = context.createCGImage(myFilter!.outputImage!, fromRect: myFilter!.outputImage!.extent)
        
        let filteredImage = UIImage(CGImage: outputCGImage)
        
        //        let context = CIContext(options: [kCIContextUseSoftwareRenderer: false])
        //        let outputImage = context.createCGImage(myFilter!.outputImage!, fromRect: myFilter!.outputImage!.extent)
        //        let filteredImage = UIImage(CGImage: self.context.createCGImage(outputImage, fromRect: outputImage!.extent()))
        self.imageView.image = filteredImage
        self.imageView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
        //        self.imageView.transform = CGAffineTransformTranslate(transform, self.size.width, 0);
        
        
        
        /*self.imageView
         static CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};
         
         - (UIImage *)imageRotatedByDegrees:(CGFloat)degrees
         {
         // calculate the size of the rotated view's containing box for our drawing space
         UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
         CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
         rotatedViewBox.transform = t;
         CGSize rotatedSize = rotatedViewBox.frame.size;
         */
    }
    
    
    @IBAction func dismissKeyboard(sender: AnyObject) {
        textView.resignFirstResponder()
    }
    
    
    @IBAction func uploadPhoto(sender: AnyObject) {
        self.addFollow()
        
        
        let newImage = self.ResizeImage(self.imageView.image!,targetSize: CGSizeMake(390, 390.0))
        
        
        let data:NSData = UIImagePNGRepresentation(newImage)!
        
        
        
        
        var storageRef: FIRStorageReference{
            return FIRStorage.storage().reference()
            
        }
        var fileUrl: String!
        
        let user = FIRAuth.auth()?.currentUser
        
        
        //Get the date
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        
        
        
        
        let filePath = "\(user!.uid)/\(timestamp)"
        let metadata =  FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storageRef.child(filePath).putData(data, metadata: metadata, completion: { (metadata, error) in
            if let error = error{
                print("\(error.description)")
                
                
                
                return
            }
            fileUrl = metadata?.downloadURLs![0].absoluteString
            
            
            
            
            
            
            //tempArray?.insertObjects(["\(fileUrl)"], atIndexes: index)
            
            
            
            
            
            self.rootRef.child("users").child("\(user!.uid)").child("images").childByAutoId().setValue("\(fileUrl!)")
            self.rootRef.child("users").child("\(user!.uid)").child("Description").childByAutoId().setValue("\(self.textView.text)")
            //
            //            self.rootRef.child("users").child("\(user!.uid)").child("location").childByAutoId().setValue("\(self.longitudeView)")
            //            self.rootRef.child("users").child("\(user!.uid)").child("location").childByAutoId().setValue("\(self.latitudeView)")
            
            
        })
        
        
        let dvc: TapBarController = (self.storyboard?.instantiateViewControllerWithIdentifier("TapBar"))! as! TapBarController
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    
    func addFollow(){
        
        // var num2: Int
        
        let post2 = rootRef.child("users").child("\(user!.uid)").child("post")
        
        
        
        post2.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            let value = snapshot.value
            
            let num = (value as! NSString).integerValue
            let num2 = num + 1
            let poste = self.rootRef.child("users").child("\(self.user!.uid)")
            
            
            poste.updateChildValues(["post" : "\(num2)"])
            
            
        })
        
        
        
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
    
}
