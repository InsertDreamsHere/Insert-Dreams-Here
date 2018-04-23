//
//  MapViewController.swift
//  Insert Dreams Here
//
//  Created by JY on 2018/3/2.
//  Copyright © 2018年 Mavey Ma. All rights reserved.
//

import UIKit
import Parse
import MapKit
import GoogleMaps


class MapViewController: UIViewController, UITableViewDataSource, CLLocationManagerDelegate {

    var Dreams: [PFObject] = []
    var locationManager = CLLocationManager()
    var mapView: GMSMapView!
    var zoomLevel: Float = 10.0

    @IBOutlet weak var mapTableView: UITableView!
    @IBOutlet weak var mapSearchBar: UISearchBar!
    override func viewDidLoad() {
      super.viewDidLoad()
        //Location Manager
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy =  kCLLocationAccuracyKilometer
        checkForLocationServices()
        locationManager.distanceFilter = 1000
        locationManager.delegate = self
        checkForLocationServices()

        // tableView
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height*0.7
        let camera = GMSCameraPosition.camera(withLatitude: -33.8683, longitude: 151.2086, zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: CGRect(x:0, y:-600, width: width, height:height), camera: camera)
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }

        print("ViewDidLoaded!")
      mapTableView.dataSource = self
      mapTableView.contentInset = UIEdgeInsets(top: 600, left: 0, bottom: 0, right: 0)
      mapTableView.contentOffset = CGPoint(x: 0, y: 1)

      mapTableView.rowHeight = UITableViewAutomaticDimension
      mapTableView.estimatedRowHeight = 500
//
//        //Asking user for location service and get user's current location
//        mapView.delegate = self
//
//        locationManager.delegate = self
//        checkForLocationServices()
//        //locationManager.requestLocation()
//        print("location Requested")
//
      fetchFromTheDatabase(tableName: "Dream")
      // fills in the color of map search bar
      let searchBarBackground = UIColor(red:0.22, green:0.23, blue:0.25, alpha:1.0)
      mapSearchBar.changeSearchBarColor(color: searchBarBackground)
      self.hideKeyboard()
        mapTableView.addSubview(mapView)
    }
//
//
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(animated)
          print("in view will appear")
          fetchFromTheDatabase(tableName: "Dream")
      }
//
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
//
//
//
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      print("Number of Dreams: !@#!@$!@#!@")
      print(self.Dreams.count)
      return Dreams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = mapTableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
      let Dream = Dreams[indexPath.row]
      cell.dreamContentLabel.text = Dream["body"] as? String
      cell.dreamTitleLabel.text = (Dream["title"] as? String) ?? "No title"
      //cell.postLocationLabel.text = Dream["paint"]
      cell.postDateLabel.text = Dream["_created_at"] as? String
      //cell.userImage
      return cell
    }
//
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      mapTableView.deselectRow(at: indexPath, animated: true)
    }
    func fetchFromTheDatabase(tableName Str: String) {
        let DreamData = PFQuery(className: "\(Str)")
        DreamData.order(byDescending: "_updated_at")
        DreamData.findObjectsInBackground(block: { (objects : [PFObject]?, error: Error?) -> Void in
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    self.Dreams = objects
//                    for dream in self.Dreams {
//                        print(dream.updatedAt!)
//                    }
                    self.mapTableView.reloadData()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        })
    }
//
    func checkForLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            // Location services are available, so query the user’s location.
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            print("location service is available")
        } else {
            // Update your app’s UI to show that the location is unavailable.
            print("location service is not available")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lat = locations.last?.coordinate.latitude, let long = locations.last?.coordinate.longitude {
            print("Printing user location")
            print("\(lat),\(long)")
            mapView.camera = GMSCameraPosition.camera(withLatitude: lat,
                                                      longitude: long,
                                                      zoom: zoomLevel)
//            let sfRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(lat, long), MKCoordinateSpanMake(0.1, 0.1))
//            mapView.setRegion(sfRegion, animated: false)
        } else {
            print("No coordinates")
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
//
}
extension UISearchBar {
  func changeSearchBarColor(color: UIColor) {
    UIGraphicsBeginImageContext(self.frame.size)
    color.setFill()
    UIBezierPath(rect: self.frame).fill()
    let bgImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    self.setSearchFieldBackgroundImage(bgImage, for: .normal)
  }
}
