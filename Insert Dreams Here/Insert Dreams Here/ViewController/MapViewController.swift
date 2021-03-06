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
  
  var Dreams: [Dream] = []
  var locationManager = CLLocationManager()
  var mapView: GMSMapView!
  var zoomLevel: Float = 7.0
  var locations: [(CLLocationCoordinate2D, String)] = []
  var markers: [GMSMarker] = []
  var queue: OperationQueue!
  var Profiles: [PFObject] = []
  
  @IBOutlet weak var mapTableView: UITableView!
  @IBOutlet weak var mapSearchBar: UISearchBar!
  override func viewDidLoad() {
    super.viewDidLoad()
    //Multi-threading
    queue = OperationQueue()
    //Location Manager
    locationManager = CLLocationManager()
    locationManager.desiredAccuracy =  kCLLocationAccuracyKilometer
    checkForLocationServices()
    locationManager.distanceFilter = 50
    locationManager.delegate = self
    checkForLocationServices()
    
    // mapView position inside tableView
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
    
    //tableView content offset; dynamic height
    print("ViewDidLoaded!")
    mapTableView.dataSource = self
    mapTableView.contentInset = UIEdgeInsets(top: 600, left: 0, bottom: 0, right: 0)
    mapTableView.contentOffset = CGPoint(x: 0, y: 1)
    
    
    mapTableView.rowHeight = UITableViewAutomaticDimension
    mapTableView.estimatedRowHeight = 200
    
    // get dreams from data base
    fetchFromTheDatabase(tableName: "Dream")
    
    // fills in the color of map search bar
    let searchBarBackground = UIColor(red:0.22, green:0.23, blue:0.25, alpha:1.0)
    mapSearchBar.changeSearchBarColor(color: searchBarBackground)
    self.hideKeyboard()
    
    // adding the mapView to the tableView
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
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("Number of Dreams:")
    print(self.Dreams.count)
    return Dreams.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = mapTableView.dequeueReusableCell(withIdentifier: "MapCell", for: indexPath) as! MapCell
    let Dream = Dreams[indexPath.row]
    
    let user = Dream.author.username
    let query = PFQuery(className: "Profile")
    query.whereKey("author", equalTo: Dream.author)
    query.includeKey("author.username")
    
    query.findObjectsInBackground (block: {(objects:[PFObject]?, error: Error?) -> Void in
        if error == nil {
            // The find succeeded.
            print("Successfully retrieved \(objects!.count) profiles.")
            if let objects = objects {
                self.Profiles = objects
                if let imageFile : PFFile = self.Profiles[0]["media"] as? PFFile {
                    imageFile.getDataInBackground(block: { (data, error) in
                        if error == nil {
                            let image = UIImage(data: data!)
                            cell.userImage.image = image
                            cell.userImage.layer.cornerRadius = cell.userImage.frame.height/2
                            cell.userImage.layer.borderWidth = 2
                            cell.userImage.layer.borderColor = UIColor.white.cgColor
                            
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            }
        } else {
            // Log details of the failure
            print("Error: \(error!)")
        }
    })
    
    
    cell.userNameLabel.text = "by " + user!
    
    cell.dreamContentLabel.text = Dream.body
    if (Dream.title.isEmpty || Dream.title.isEmpty)
    {
      cell.dreamTitleLabel.text = "Untitled"
    }
    else{
      cell.dreamTitleLabel.text = Dream.title
    }
    let formatter = DateFormatter()
    // initially set the format based on your datepicker date
    formatter.dateFormat = "MM/dd/yyyy HH:mm:ssZ"
    let myString = formatter.string(from: Dream.createdAt!)
    // convert your string to date
    let yourDate = formatter.date(from: myString)
    //then again set the date format which type of output you need
    formatter.dateFormat = "MMM dd, yyyy"
    // again convert your date to string
    var Datelabel = formatter.string(from: yourDate!)
    cell.postDateLabel.text = Datelabel
    
    formatter.dateFormat = "h:mm a"
    // again convert your date to string
    Datelabel = formatter.string(from: yourDate!)
    cell.postTimeLabel.text = Datelabel
    
    
    cell.postLocationLabel.text = Dream["location"] as? String
    //cell.userImage
    return cell
  }
  
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    mapTableView.deselectRow(at: indexPath, animated: true)
  }
  func fetchFromTheDatabase(tableName Str: String) {
    //Kick it to other thread
    let operation = BlockOperation{
      let query = Dream.query()
      query?.order(byDescending: "createdAt")
      query?.includeKey("author.username")
      query?.includeKey("createdAt")
      //query?.whereKey("author", equalTo: PFUser.current()!)
      query?.limit = 20
      //            let DreamData = PFQuery(className: "\(Str)")
      //            DreamData.order(byDescending: "_updated_at")
      //            DreamData.includeKey("author.username")
      query?.findObjectsInBackground(block: { (Dream, error: Error?) -> Void in
        if error == nil {
          // The find succeeded.
          print("Successfully retrieved \(Dream!.count) scores.")
          // Do something with the found objects
          if let dreams = Dream {
            self.Dreams = dreams as! [Dream]
            if (Str == "Dream"){
              for dream in self.Dreams{
                if (dream["latitude"] != nil && dream["longitude"] != nil){
                  //                        let tuple = (CLLocationCoordinate2D(latitude: Double(dream["latitude"] as! String)!, longitude: Double(dream["latitude"] as! String)!), dream["title"] as! String)
                  //                        self.locations.append(tuple)
                  let position = CLLocationCoordinate2D(latitude: Double(dream["latitude"] as! String)!, longitude: Double(dream["longitude"] as! String)!)
                  let marker = GMSMarker(position: position)
                  marker.title = dream["title"] as? String
                  self.markers.append(marker)
                  print("Number of markers: \(self.markers.count)")
                }
              }
            }
            OperationQueue.main.addOperation {
              for m in self.markers {
                m.map = self.mapView
              }
            }
            self.mapTableView.reloadData()
          }
        } else {
          // Log details of the failure
          print("Error: \(error!)")
        }
      })
    }
    queue.addOperation(operation)
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
