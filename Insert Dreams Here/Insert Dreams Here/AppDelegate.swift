//
//  AppDelegate.swift
//  Insert Dreams Here
//
//  Created by Mavey Ma on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import Parse
import GooglePlaces
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    // All navigation controllers shall have white status bar
    UINavigationBar.appearance().barStyle = .blackOpaque

    // Set up Parse server
    Parse.initialize(
      with: ParseClientConfiguration(block: { (configuration: ParseMutableClientConfiguration) -> Void in
        configuration.applicationId = "InsertDreamsHere"
        configuration.clientKey = "ajsdfjoJSDfj234sdf" // set to nil assuming you have not set clientKey
        configuration.server = "http://insert-dreams-here.herokuapp.com/parse"
      }))

    // check if user is logged in.
    if PFUser.current() != nil {
      // Load and show the home view controller
      self.changeViewTo(targetViewController: "AuthenticatedTabBarController")
    }

    // Keep a look out for if user clicked "Logout"
    NotificationCenter.default.addObserver(forName: Notification.Name("didLogout"), object: nil, queue: OperationQueue.main) { (Notification) in
      print("Logout notification received")
      self.logOut()
    }

    // Keep a look out for if user clicked "Cancel"
    NotificationCenter.default.addObserver(forName: Notification.Name("didCancel"), object: nil, queue: OperationQueue.main) { (Notification) in
      print("Logout notification received")
      self.logOut()
    }

    // Google Map API
    GMSServices.provideAPIKey("AIzaSyA63muLcvuCIqFWrjxVRpuiDP7VyIg0d68")
    GMSPlacesClient.provideAPIKey("AIzaSyAunszbf5Rn7Gv9XyIPXAvTKnszK9NGLys")

    return true
  }

  func changeViewTo(targetViewController: String) {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let targetVC = storyboard.instantiateViewController(withIdentifier: targetViewController)
    self.window?.rootViewController = targetVC
  }

  func logOut() {
    // Logout the current user
    PFUser.logOutInBackground(block: { (error) in
      if let error = error {
        print(error.localizedDescription)
      } else {
        print("Successful logout")
        // Load and show the login view controller
        self.changeViewTo(targetViewController: "LoginViewController")
      }
    })
    // Load and show the login view controller

  }

  func registerForPushNotifications() {
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
      (granted, error) in
      print("Permission granted: \(granted)")

      guard granted else { return }
      self.getNotificationSettings()
    }
  }

  //Useful if user declines the permissions
  func getNotificationSettings() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
      print("Notification settings: \(settings)")
      guard settings.authorizationStatus == .authorized else { return }
      UIApplication.shared.registerForRemoteNotifications()
    }
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }

  func application(_ application: UIApplication,
                   didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    let tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)
    }

    let token = tokenParts.joined()
    print("Device Token: \(token)")
  }

  func application(_ application: UIApplication,
                   didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
  }
}
