//
//  AVCamPreviewView.swift
//  Graf
//
//  Created by Mohamed on 6/19/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//


import Foundation
import UIKit
import AVFoundation


class AVCamPreviewView: UIView{
    
    var session: AVCaptureSession? {
        get{
            return (self.layer as! AVCaptureVideoPreviewLayer).session;
        }
        set(session){
            (self.layer as! AVCaptureVideoPreviewLayer).session = session;
        }
    };
    
    
    
    override class func layerClass() ->AnyClass{
        return AVCaptureVideoPreviewLayer.self;
    }
    
    
    
    
    
    
    
    
    
}
