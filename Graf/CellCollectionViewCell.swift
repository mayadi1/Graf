//
//  CellCollectionViewCell.swift
//  Graf
//
//  Created by Mohamed on 6/20/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import Foundation
import UIKit

class CellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    
        
    func configureCell(photo: Photo) {
        
        
        let temp = NSURL.init(string: photo.urlTemp)
       
        
        
        if temp != nil {
            if let data = NSData(contentsOfURL: temp!){
                                
              
             self.imageView!.image =  UIImage.init(data: data)
            
                self.imageView.transform  = CGAffineTransformMakeRotation(CGFloat(M_PI_2));
}
        }
        

            
        
       
    }
    
  
    

}
