//
//  Map.swift
//  Graf
//
//  Created by Mohamed on 6/24/16.
//  Copyright © 2016 Mohamed. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class Map: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
        let chicago = MKPointAnnotation()
    
    let rootRef = FIRDatabase.database().reference()
    let user = FIRAuth.auth()?.currentUser

    var latArray = [Double]()
    var lonArray = [Double]()
    
    var cord = [String]()
    var cordLong = [String]()
    var cordLat = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
//        
//        mapView.setRegion(MKCoordinateRegionMake(chicago.annotation!.coordinate, MKCoordinateSpanMake(0.05, 0.05)), animated: true)

        
        self.navigationItem.title = "Map"
        mapView.showsUserLocation = true
        
        
        
        
        let latitude = 41.8812422
        let longitude = -87.6345985
        
        chicago.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
        
        
         mapView.setRegion(MKCoordinateRegionMake(chicago.coordinate, MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
      
        
        self.dropPinForCordinate(latitude, longtitude: longitude, index: 0)
        
     
        
        
        
        let user = SignInViewController.dataService.returnUser()
        
        let conditionRed = rootRef.child("users").child("\(user!.uid)")
        
        conditionRed.observeSingleEventOfType(.Value, withBlock:  { (snapshot) in
            
            //  let key = snapshot.key
            
            let di = snapshot.value as! NSDictionary
            
            
           let d = di.valueForKey("location")
     
            let loc = d?.allValues as! [String]
           
            for latLon in loc {
     
                if loc.indexOf(latLon)! % 2 == 0 {
                    let lat = Double(latLon)!
                    self.latArray.append(lat)
                } else {
                    let lon = Double(latLon)!
                    self.lonArray.append(lon)
                }
                
            }
            
                
    
             
            
        })
        
        
        
        self.loadMap()

        
        
    }//End of the viewDidLoad
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        pin.canShowCallout = true
        
        pin.rightCalloutAccessoryView = UIButton(type: .InfoLight)
        
        return pin
        
        
        
        
    }
    
    func dropPinForCordinate(latitude:Double, longtitude:Double, index:Int) {
        let mobileMakersAnnotation = MKPointAnnotation()
      
        mobileMakersAnnotation.coordinate = CLLocationCoordinate2DMake(latitude, longtitude)
        mapView.addAnnotation(mobileMakersAnnotation)
    }
    
    
    
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // mapView.setRegion(MKCoordinateRegionMake(view.annotation!.coordinate, MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
     
        
        
        
        
    }
    
    
    
    func loadMap(){
        
        var i = 0
        for item in self.latArray
        {
            
            
            self.dropPinForCordinate(item, longtitude: self.lonArray[i], index: 0)
//            mapView.reloadInputViews()
            i = i + 1
        }
    }
   
}
