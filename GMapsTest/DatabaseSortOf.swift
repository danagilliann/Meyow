//
//  DatabaseSortOf.swift
//  GMapsTest
//
//  Created by Dana on 8/9/15.
//  Copyright (c) 2015 Jessica Joseph. All rights reserved.
//

import Foundation

// Start: Finding users in database
//var query = PFQuery(className: "appUser")
//query.whereKey("userPhoneNumber", equalTo: userId)
//query.findObjectsInBackgroundWithBlock({ (AnyObject, error) -> Void in
//    if (AnyObject != nil) {
//        // User automatically logs in
//    }
//    else
//    {
//        // User must log in
//    }
//    
//})
//// End
//
//
////println("User Id \(userId)")
//
//// Start: This starts a class in the database. AKA column
//var appUser = PFObject(className: "appUser")
//// End
//
//// Start: stores user id as a key/value like a dictionary
////appUser["userId"] = userId
//appUser["userPhoneNumber"] = "9177527628"
//// End
//
//
//// Start: This saves our data
//appUser.saveInBackgroundWithBlock { (success, error) -> Void in
//    if (success)
//    {
//        // good
//    }
//    else
//    {
//        // not good
//    }
//}
//// End