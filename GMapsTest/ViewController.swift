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
            
            //print("hello")
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
        
        //marker.title = "SEND MEOW"
        marker.position = CLLocationCoordinate2DMake(myLat, myLong)
        
        let markerButton = UIButton(frame: CGRectMake(60, 50, 100, 70))
        self.view.addSubview(markerButton)
        markerButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        markerButton.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        markerButton.setTitle(marker.title, forState: UIControlState.Normal)
        markerButton.backgroundColor = UIColor.blackColor()
        
        marker.map = mapView
        
    }
    
    func pressed(sender: UIButton) {
        
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if error == nil {
                // do something with the new geoPoint
                
                var myLat = geoPoint.latitude
                var myLong = geoPoint.longitude
            }
        }
        
        let point = PFGeoPoint(latitude: myLat, longitude: myLong)
        var placeObject = PFObject(className: "locationOfMeows")
        placeObject["location"] = point

    }
   
    func returnUserData()
    {
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
    

}

