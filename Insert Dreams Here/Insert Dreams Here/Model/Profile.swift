//
//  Profile.swift
//  Insert Dreams Here
//
//  Created by Michael Fletes on 4/9/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import Foundation
import Parse

class Profile: PFObject, PFSubclassing {
    @NSManaged var author: PFUser
    @NSManaged var dateJoined: Date
    @NSManaged var location: String
    @NSManaged var bio: String
    @NSManaged var image: UIImage
    
    /* Needed to implement PFSubclassing interface */
    class func parseClassName() -> String {
        return "Profile"
    }
    
    /**
     Method to add a user dream to Parse
     - parameter content: Dream text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func createProfile(withLocation location: String?, withBio bio: String?, withImage image: UIImage?, withCompletion completion: PFBooleanResultBlock?) {
        // use subclass approach
        let profile = Profile()
        
        // Add relevant fields to the object
        profile.author = PFUser.current()! // Pointer column type that points to PFUser
        profile.location = location!
        profile.bio = bio!
        //profile.image = image!
        profile.dateJoined = PFUser.current()!.createdAt!
        
        // Save object (following function will save the object in Parse asynchronously)
        profile.saveInBackground(block: completion)
    }
}
