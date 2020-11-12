//
//  A3_HomeRouteDrawViewController.swift
//  Hiking
//
//  Created by Will Lam on 5/11/2020.
//

import UIKit
import CoreLocation
import MapKit
import Contacts

protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class A3_HomeRouteDrawViewController: UIViewController, CLLocationManagerDelegate {
    
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil

    @IBOutlet weak var mapView: MKMapView!
    
    var currentPlacemark: CLPlacemark?
    var currentPostalAddress: CNPostalAddress?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.requestLocation()
        
        // Insert the location search table during inputting in the search bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "A3_LocationSeatchTableID") as! A3_LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Actions

//    if let address = place_textField.text {
//        CLGeocoder().geocodeAddressString(address) {
//            (placemarks, error) in
//            if error != nil {
//                print("Geo failed with error: \(error!.localizedDescription)")
//            } else if let marks = placemarks, marks.count > 0 {
//                let placemark = marks[0]
//                if let location = placemark.location {
//                    CLGeocoder().reverseGeocodeLocation(location) {
//                        (p, e) in
//                        if e != nil {
//                            print("Reverse geo failed with error: \(error!.localizedDescription)")
//                        } else if let m = p, m.count > 0 {
//                            let pm = m[0] as CLPlacemark
//                            self.currentPlacemark = pm
//                            if let add = pm.postalAddress {
//                                self.currentPostalAddress = add
//                            }
//                        }
//                    }
//                }
//
//            }
//        }
//
//        if let pm = currentPlacemark, let loc = pm.location {
//            let searchCenter = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
//            let searchRegion = MKCoordinateRegion(center: searchCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            mapView.setRegion(searchRegion, animated: true)
//
//            let pin = MKPlacemark(coordinate: searchCenter)
//            mapView.addAnnotation(pin)
//        }
//    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let userRegion = MKCoordinateRegion(center: userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(userRegion, animated: true)
        
        print("Location changed! \(locations.count) location(s) detected")
        for item in locations {
            print("\(item)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}


// MARK: - Extension

extension A3_HomeRouteDrawViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        selectedPin = placemark // cache the pin
        mapView.removeAnnotations(mapView.annotations) // clear existing pins
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
           let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
}
