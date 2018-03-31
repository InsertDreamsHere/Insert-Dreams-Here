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
  
  /* Needed to implement PFSubclassing interface */
  class func parseClassName() -> String {
    return "Dream"
  }
  
  /**
   Method to add a user dream to Parse
   - parameter content: Dream text input by the user
   - parameter completion: Block to be executed after save operation is complete
   */
  class func sendDream(withContent content: String?, withCompletion completion: PFBooleanResultBlock?) {
    // use subclass approach
    let dream = Dream()
    
    // Add relevant fields to the object
    dream.author = PFUser.current()! // Pointer column type that points to PFUser
    dream.body = content!
  
    // Save object (following function will save the object in Parse asynchronously)
    dream.saveInBackground(block: completion)
  }
}
