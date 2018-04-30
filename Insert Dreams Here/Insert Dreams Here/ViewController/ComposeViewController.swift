//
//  ComposeViewController.swift
//  Insert Dreams Here
//
//  Created by Mavey Ma on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import GooglePlaces
import GooglePlacePicker
import FlagKit
import Parse
class ComposeViewController: UIViewController, UITextViewDelegate{
  
  @IBOutlet weak var dreamBody: UITextView!
  @IBOutlet weak var dreamTitle: UITextView!
  @IBOutlet weak var selectLocationButton: UIButton!
  
  @IBOutlet weak var charCountLabel: UILabel!
  var characterLimit: Int = 50
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var roundFlagImage: UIImageView!
  @IBOutlet weak var flagImage: UIImageView!
  var placesClient: GMSPlacesClient!
  var selectedLocation: CLLocationCoordinate2D!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    placesClient = GMSPlacesClient.shared()
    setDefaultLocation()
    self.hideKeyboard()
    dreamTitle.delegate = self
    charCountLabel.text = String(characterLimit)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    // Construct what the new text would be if we allowed the user's latest edit
    let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)
    
    // Update Character Count Label
    charCountLabel.text = String(characterLimit - newText.count)
    
    // The new text should be allowed? True/False
    return newText.count < characterLimit
  }
  
  func setDefaultLocation() {
    placesClient.currentPlace { (placeLikelihoodList, error) in
      if let error = error {
        print("Pick Place error: \(error.localizedDescription)")
        return
      }
      self.flagImage.image = #imageLiteral(resourceName: "placeholder")
      self.locationLabel.text = "Select Location"
      if let placeLikelihoodList = placeLikelihoodList {
        let place = placeLikelihoodList.likelihoods.first?.place
        if let place = place {
          self.locationLabel.text = "Current Location"
          self.setCurrentCoordinates(myPlace: place)
        }
      }
    }
  }
  
  func setCurrentCoordinates(myPlace: GMSPlace) {
    self.selectedLocation = myPlace.coordinate
    let lat = myPlace.coordinate.latitude
    let long = myPlace.coordinate.longitude
    print("Check current coordinates CLLocationCoordinate2D: \(lat),\(long)")
  }
  
  @IBAction func onTapSelectLocationButton(_ sender: Any) {
    // Create a place picker. Attempt to display it as a popover if we are on a device which
    // supports popovers.
    let config = GMSPlacePickerConfig(viewport: nil)
    let placePicker = GMSPlacePickerViewController(config: config)
    placePicker.delegate = self
    placePicker.modalPresentationStyle = .popover
    placePicker.popoverPresentationController?.sourceView = selectLocationButton
    placePicker.popoverPresentationController?.sourceRect = selectLocationButton.bounds
    
    // Display the place picker. This will call the delegate methods defined below when the user
    // has made a selection.
    self.present(placePicker, animated: true, completion: nil)
  }
  
  func updateLocationLabel(myPlace: GMSPlace) {
    print(myPlace)
    if (myPlace.addressComponents != nil) {
      let city = self.getAddressComponent(ofType: "locality", addrComponents: myPlace.addressComponents!)
      let state = self.getAddressComponent(ofType: "administrative_area_level_1", addrComponents: myPlace.addressComponents!)
      let country = self.getAddressComponent(ofType: "country", addrComponents: myPlace.addressComponents!)
      self.setFlag(countryName: country)
      let location = city + ", " + state + ", " + country
      self.locationLabel.text = location
    } else {
      //"Select this location" option in PlacePicker was selected, which does not have an address, only coordinates
      self.flagImage.image = #imageLiteral(resourceName: "placeholder")
      self.locationLabel.text = "Please select a city or country."
    }
    
  }
  
  func getAddressComponent(ofType partOfAddress: String, addrComponents: [GMSAddressComponent]) -> String {
    var part = "N/A"
    for component in addrComponents {
      if component.type == partOfAddress {
        part = component.name
      }
    }
    return part
  }
  
  func setFlag(countryName: String) {
    let shortCode = locale(for: countryName)
    let flag = Flag(countryCode: shortCode)
    
    if let flag = flag {
      //self.flagImage.image = flag.originalImage
      self.flagImage.image = flag.image(style: .circle)
    }
    else {
      self.flagImage.image = #imageLiteral(resourceName: "placeholder")
    }
  }
  
  //https://stackoverflow.com/questions/12671829/get-country-code-from-country-name-in-ios
  private func locale(for fullCountryName : String) -> String {
    let locales : String = ""
    for localeCode in NSLocale.isoCountryCodes {
      let identifier = NSLocale(localeIdentifier: localeCode)
      let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
      if fullCountryName.lowercased() == countryName?.lowercased() {
        return localeCode
      }
    }
    return locales
  }
  
  func popUpMessage(title: String, message: String, confirmation: String) {
    let alertControllerError = UIAlertController(title: title, message: message, preferredStyle: .alert)
    // create a cancel action
    let cancelAction = UIAlertAction(title: confirmation, style: .cancel) { (action) in
      // handle cancel response here. Doing nothing will dismiss the view.
    }
    // add the cancel action to the alertController
    alertControllerError.addAction(cancelAction)
    present(alertControllerError, animated: true)
  }
  
  
  func dreamCountIncrementByOne() {
    let query = PFQuery(className:"Profile")
    query.whereKey("author", equalTo: PFUser.current()!)
    query.findObjectsInBackground (block: {(objects:[PFObject]?, error: Error?) -> Void in
      if error == nil {
        objects![0].incrementKey("dreamCount")
        objects![0].saveInBackground {
          (success: Bool, error: Error?) in
          if (success) {
            print("Dream count incremented successfully")
          } else {
            print("Dream count error incrementing: \(String(describing: error))")
          }
        }
      }
    })
  }
  
  @IBAction func onPost(_ sender: Any) {
    print("Clicked share")
    dreamBody.resignFirstResponder()
    if dreamBody.text.isEmpty {
      self.popUpMessage(title: "Missing Dream Content", message: "Please enter a dream first.", confirmation: "OK")
    } else if selectedLocation == nil {
      self.popUpMessage(title: "Missing Location Tag", message: "To pin your dream on the map, please select a location with a name.", confirmation: "OK")
    } else {
      if let selectedLocation = selectedLocation {
        //If user doesn't set a title, grab the first 50 char from dream body
        if dreamTitle.text.isEmpty {
          var lengthOfTitle = 50
          if dreamBody.text.count < lengthOfTitle {
            lengthOfTitle = dreamBody.text.count
          }
          dreamTitle.text = String(dreamBody.text.prefix(lengthOfTitle))
          charCountLabel.text = String(characterLimit - dreamTitle.text.count)
        }
        let selectedLat = selectedLocation.latitude.description
        let selectedLon = selectedLocation.longitude.description
        Dream.sendDream(withContent: dreamBody.text, title: dreamTitle.text, lat: selectedLat, lon: selectedLon, loc: locationLabel.text) { (success, error) in
          if success {
            print("Great new dream!")
            self.dreamCountIncrementByOne()
          } else if let e = error as NSError? {
            print(e.localizedDescription)
            print("Something went wrong with your dream post.")
          }
        }
      }
    }
  }
  
}

extension ComposeViewController: GMSPlacePickerViewControllerDelegate {
  func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
    self.updateLocationLabel(myPlace: place)
    self.setCurrentCoordinates(myPlace: place)
    // Dismiss the place picker.
    viewController.dismiss(animated: true, completion: nil)
  }
  
  func placePicker(_ viewController: GMSPlacePickerViewController, didFailWithError error: Error) {
    self.flagImage.image = #imageLiteral(resourceName: "placeholder")
    self.locationLabel.text = "Select a location tag"
    NSLog("An error occurred while picking a place: \(error)")
  }
  
  func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
    NSLog("The place picker was canceled by the user")
    // Dismiss the place picker.
    viewController.dismiss(animated: true, completion: nil)
  }
}

extension UIViewController
{
  func hideKeyboard()
  {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(UIViewController.dismissKeyboard))
    
    view.addGestureRecognizer(tap)
  }
  
  @objc func dismissKeyboard()
  {
    view.endEditing(true)
  }
}
