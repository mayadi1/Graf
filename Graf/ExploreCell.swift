//
//  ExploreCell.swift
//  Graf
//
//  Created by Mohamed on 6/23/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit

class ExploreCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    
    
    func configureCell(photo: UIImage) {
        
        
        
        imageView.image = photo
        imageView.transform  = CGAffineTransformMakeRotation(CGFloat(M_PI_2));

    }
    

}
