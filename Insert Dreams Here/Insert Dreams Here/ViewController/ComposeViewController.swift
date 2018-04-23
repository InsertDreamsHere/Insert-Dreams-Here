//
//  ComposeViewController.swift
//  Insert Dreams Here
//
//  Created by Mavey Ma on 3/2/18.
//  Copyright © 2018 Mavey Ma. All rights reserved.
//

import UIKit
import GooglePlaces

class ComposeViewController: UIViewController {

  @IBOutlet weak var dreamBody: UITextView!
  @IBOutlet weak var dreamTitle: UITextView!
  @IBOutlet weak var selectLocationButton: UIButton!
  
  var placesClient: GMSPlacesClient!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    placesClient = GMSPlacesClient.shared()
    self.hideKeyboard()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  @IBAction func onTapSelectLocationButton(_ sender: Any) {
    //self.performSegue(withIdentifier: "tagSegue", sender: nil)
    placesClient.currentPlace { (placeLikelihoodList, error) in
      if let error = error {
        print("Pick Place error: \(error.localizedDescription)")
        return
      }
      self.selectLocationButton.setTitle("No current place", for: .normal)
      if let placeLikelihoodList = placeLikelihoodList {
        let place = placeLikelihoodList.likelihoods.first?.place
        if let place = place {
          let city = self.getAddressComponent(ofType: "locality", addrComponents: place.addressComponents!)
          
          let state = self.getAddressComponent(ofType: "administrative_area_level_1", addrComponents: place.addressComponents!)
          
          let country = self.getAddressComponent(ofType: "country", addrComponents: place.addressComponents!)
          
          print(city)
          
          let location = city + ", " + state + ", " + country
          self.selectLocationButton.setTitle(location, for: .normal)
        }
      }
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
  
  func getCity(addrComponents: [GMSAddressComponent]) -> String {
    var city = "No city"
    for component in addrComponents {
      if component.type == "locality" {
        city = component.name
        print(city)
      }
    }
    return city
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
