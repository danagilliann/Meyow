//
//  ViewController.swift
//  GMapsTest
//
//  Created by Jessica Joseph on 8/8/15.
//  Copyright (c) 2015 Jessica Joseph. All rights reserved.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController, FBSDKLoginButtonDelegate, CLLocationManagerDelegate {
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
            
            let loginView : FBSDKLoginButton = FBSDKLoginButton()

            
            if (FBSDKAccessToken.currentAccessToken() != nil)
            {
                // User is already logged in, do work such as go to next view controller.
                
                // Or Show Logout Button
                self.view.addSubview(loginView)
                loginView.center = self.view.center
                loginView.readPermissions = ["public_profile", "email", "user_friends"]
                loginView.delegate = self
                self.returnUserData()
            }
            else
            {
                self.view.addSubview(loginView)
                loginView.center = self.view.center
                loginView.readPermissions = ["public_profile", "email", "user_friends"]
                loginView.delegate = self
            }
        
    }
    
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
                println("hello")
            }
            
            self.returnUserData()
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func pressed(markerButton:UIButton) {
        let geoPoint = PFGeoPoint(latitude: 40.7531589, longitude: -73.9893598)
        
        println("In function")
        var marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude)
        
        var placeObject = PFObject(className: "locationOfMeows")
        placeObject["location"] = geoPoint
        placeObject.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("Success")
                
                var alertView = UIAlertView();
                alertView.addButtonWithTitle("Ok");
                alertView.title = "Meow Sent!";
                alertView.show();
                
    
            } else {
                println("Not saved")
                // There was a problem, check error.description
            }
            
        }
    }
    
    func moreMeowsButtonFunc(moreMeows:UIButton) {
        println("In more meows func")
        
        var point = [PFGeoPoint]()
        
        point.append(PFGeoPoint(latitude:40.753189, longitude:-73.9893598))
        point.append(PFGeoPoint(latitude:41.2759, longitude:-73.2894))
        point.append(PFGeoPoint(latitude:4.3, longitude:-73.7821))
        point.append(PFGeoPoint(latitude:40.0, longitude:-73.2873))
        point.append(PFGeoPoint(latitude:41.12780, longitude:-73.29837))
        point.append(PFGeoPoint(latitude:41.8932, longitude:-72.98273))
        point.append(PFGeoPoint(latitude: 41.3122, longitude:-72.9283))
        point.append(PFGeoPoint(latitude:40.84934, longitude:-73.8932))
        point.append(PFGeoPoint(latitude:41.2478, longitude:-73.8324))
        point.append(PFGeoPoint(latitude:41.2112, longitude:-73.3874))
        point.append(PFGeoPoint(latitude:41.9575, longitude:-72.9203))
        point.append(PFGeoPoint(latitude:40.5639, longitude:-73.193))
        point.append(PFGeoPoint(latitude:41.9473, longitude:-72.8902))
        point.append(PFGeoPoint(latitude:40.124, longitude:-73.1946439))
        
        for p in point {
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(p.latitude, p.longitude)
            //marker.map = mapView
            println(p)
            
        }
    }
    
    func googleMaps() {
        let locationManager = CLLocationManager()
        
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        var currentPosition = CLLocation()
        
        
        var myLat = 40.7531589 //currentPosition.coordinate.latitude
        var myLong = -73.9893598 //currentPosition.coordinate.longitude
        
        
        var camera = GMSCameraPosition.cameraWithLatitude(myLat, longitude: myLong, zoom: 18, bearing: 7, viewingAngle: 0)
        var mapView = GMSMapView.mapWithFrame(CGRectZero, camera: camera)
        mapView.myLocationEnabled = true
        self.view = mapView
        
        
        var marker = GMSMarker()
        
        marker.position = CLLocationCoordinate2DMake(myLat, myLong)
        
        
        let markerButton = UIButton(frame: CGRectMake(110, 550, 150, 40))
        self.view.addSubview(markerButton)
        markerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        markerButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        markerButton.setTitle("SEND MEOW", forState: UIControlState.Normal)
        markerButton.backgroundColor = UIColor.blackColor()
        markerButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
        let moreMeows = UIButton(frame: CGRectMake(110, 600, 150, 40))
        self.view.addSubview(moreMeows)
        moreMeows.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        moreMeows.addTarget(self, action: "moreMeowsButtonFunc:", forControlEvents: .TouchUpInside)
        moreMeows.setTitle("VIEW MEOWS", forState: UIControlState.Normal)
        moreMeows.backgroundColor = UIColor.blackColor()
        moreMeows.titleLabel?.adjustsFontSizeToFitWidth = true
        
        marker.map = mapView
        
    }
    
    func returnUserData() {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
                println("fetched user: \(result)")
                let userName : NSString = result.valueForKey("name") as! NSString
                println("User Name is: \(userName)")
                let userId : NSString = result.valueForKey("id") as! NSString
                
                
                self.googleMaps()
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func seeOther(){
//        PFGeoPoint.geoPointForCurrentLocationInBackground {
//            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
//            if error == nil {
//                // do something with the new geoPoint
//                // Create a query for places
//                var query = PFQuery(className:"locationOfMeows")
//                // Interested in locations near user.
//                query.whereKey("location", nearGeoPoint:geoPoint!)
//                // Limit what could be a lot of points.
//                query.limit = 100
//                // Final list of objects
//                var objects = query.findObjects()
//                
//                if let objects = objects as? [PFObject] {
//                    for object in objects {
//                        var marker = GMSMarker()  //can be more efficient, but it works for now!!
//                        var point = object["location"] as! PFGeoPoint
//                        marker.position = CLLocationCoordinate2DMake(point.latitude, point.longitude)
//                    }
//                }
//            }
//            else
//            {
//                // Log details of the failure
//                println("Error: \(error!) \(error!.userInfo!)")
//            }
//        }
//    }
    

    
}




   







