//
//  Dream.swift
//  Insert Dreams Here
//
//  Created by Mavey Ma on 3/31/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import Foundation
import Parse

class Dream: PFObject, PFSubclassing {
    @NSManaged var author: PFUser
    @NSManaged var body: String
    @NSManaged var title: String
    @NSManaged var latitude: String
    @NSManaged var longitude: String
    //Added location to show where the dream was recorded
    @NSManaged var location: String
    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "Dream"
    }
    
    /**
     Method to add a user dream to Parse
     - parameter content: Dream text input by the user
     - parameter title: Dream title input by the user
     - parameter lat: Dream latitude from location tag picked by the user
     - parameter lon: Dream longitude from location tag picked by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func sendDream(withContent content: String?, title: String?, lat: String?, lon: String?, loc:String?, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let dream = Dream()
        
        // Add relevant fields to the object
        dream.author = PFUser.current()! // Pointer column type that points to PFUser
        dream.title = title!
        dream.latitude = lat!
        dream.longitude = lon!
        dream.body = content!
        dream.location = loc!
        // Save object (following function will save the object in Parse asynchronously)
        dream.saveInBackground(block: completion)
    }
}
