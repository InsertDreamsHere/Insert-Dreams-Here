//
//  User.swift
//  Insert Dreams Here
//
//  Created by Mavey Ma on 3/31/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import Foundation
import Parse
enum UserKeys {
  static let ID = "_id"
  static let handle = "username"
  static let joinStamp = "_created_at"
  static let profilePicture = "profile_pic"
  static let realName = "name"
  static let aboutMe = "bio"
  static let myLocation = "location"
}

class User {
  var ID: String
  var handle: String
  var joinStamp: String
  var profilePicture: URL?
  var realName: String?
  var aboutMe: String?
  var myLocation: String?
  
  // For user persistance
  var dictionary: [String: Any]?
  
  init(dictionary: [String: Any]) {
    self.dictionary = dictionary
    ID = dictionary[UserKeys.ID] as! String
    handle = dictionary[UserKeys.handle] as! String
    joinStamp = dictionary[UserKeys.joinStamp] as! String
    profilePicture = dictionary[UserKeys.profilePicture] as? URL
    realName = dictionary[UserKeys.realName] as? String
    aboutMe = dictionary[UserKeys.aboutMe] as? String
    myLocation = dictionary[UserKeys.myLocation] as? String
  }
  
}
