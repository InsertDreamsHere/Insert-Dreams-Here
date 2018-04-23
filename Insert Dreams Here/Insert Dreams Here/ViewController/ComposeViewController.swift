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

class ComposeViewController: UIViewController {
  
  @IBOutlet weak var dreamBody: UITextView!
  @IBOutlet weak var dreamTitle: UITextView!
  @IBOutlet weak var selectLocationButton: UIButton!
  
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var roundFlagImage: UIImageView!
  @IBOutlet weak var flagImage: UIImageView!
  var placesClient: GMSPlacesClient!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    placesClient = GMSPlacesClient.shared()
    setDefaultLocation()
    self.hideKeyboard()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func setDefaultLocation() {
    placesClient.currentPlace { (placeLikelihoodList, error) in
      if let error = error {
        print("Pick Place error: \(error.localizedDescription)")
        return
      }
      self.locationLabel.text = "No current place"
      if let placeLikelihoodList = placeLikelihoodList {
        let place = placeLikelihoodList.likelihoods.first?.place
        if let place = place {
          self.updateLocationLabel(myPlace: place)
        }
      }
    }
  }
  
  @IBAction func onTapSelectLocationButton(_ sender: Any) {
    let center = CLLocationCoordinate2D(latitude: 37.788204, longitude: -122.411937)
    let northEast = CLLocationCoordinate2D(latitude: center.latitude + 0.001, longitude: center.longitude + 0.001)
    let southWest = CLLocationCoordinate2D(latitude: center.latitude - 0.001, longitude: center.longitude - 0.001)
    let viewport = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)
    let config = GMSPlacePickerConfig(viewport: viewport)
    let placePicker = GMSPlacePicker(config: config)
    
    placePicker.pickPlace(callback: {(place, error) -> Void in
      if let error = error {
        print("Pick Place error: \(error.localizedDescription)")
        return
      }
      self.locationLabel.text = "No current place picked"
      if let place = place {
        self.updateLocationLabel(myPlace: place)
      }
      
    })
  }
  
  func updateLocationLabel(myPlace: GMSPlace) {
    let city = self.getAddressComponent(ofType: "locality", addrComponents: myPlace.addressComponents!)
    let state = self.getAddressComponent(ofType: "administrative_area_level_1", addrComponents: myPlace.addressComponents!)
    let country = self.getAddressComponent(ofType: "country", addrComponents: myPlace.addressComponents!)
    self.setFlag(countryName: country)
    let location = city + ", " + state + ", " + country
    self.locationLabel.text = location
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
  
  @IBAction func onPost(_ sender: Any) {
    print("Clicked share")
    dreamBody.resignFirstResponder()
    Dream.sendDream(withContent: dreamBody.text, title: dreamTitle.text) { (success, error) in
      if success {
        print("Great new dream!")
      } else if let e = error as NSError? {
        print(e.localizedDescription)
        print("Something went wrong with your dream post.")
      }
    }
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

