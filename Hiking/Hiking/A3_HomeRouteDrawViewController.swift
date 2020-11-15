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

// Protocol for dropping the pin after searching in serach bar
protocol HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class A3_HomeRouteDrawViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var currentPlacemark: CLPlacemark?
    var selectedPin: MKPlacemark? = nil
    var locationManager: CLLocationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else {
            locationManager.requestLocation()
        }
        
        // Insert the location search table during inputting in the search bar
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "A3_LocationSeatchTableID") as! A3_LocationSearchTableViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        // Insert the search bar in the navigation bar
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        // Insert the Long Press Gesture Recognizer in the map
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(self.addAnnotation(gestureRecognizer:)))
        longPress.minimumPressDuration = 0.7
        mapView.addGestureRecognizer(longPress)
    }
    
    @objc func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates

            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }

                if placemarks!.count > 0 {
                    let pm = placemarks![0]

                    // not all places have thoroughfare & subThoroughfare so validate those values
                    annotation.title = pm.thoroughfare ?? "" + (pm.subThoroughfare ?? "")
                    annotation.subtitle = pm.subLocality
                    self.mapView.addAnnotation(annotation)
                    print(pm)
                } else {
                    annotation.title = "Unknown Place"
                    self.mapView.addAnnotation(annotation)
                    print("Problem with the data received from geocoder")
                }
//            places.append(["name":annotation.title,"latitude":"\(newCoordinates.latitude)","longitude":"\(newCoordinates.longitude)"])
            })
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard manager.authorizationStatus == .authorizedWhenInUse else {
            return
        }
        manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0] as CLLocation
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
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myMarker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -10, y: 5)
            view.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.leftCalloutAccessoryView?.largeContentTitle = "selectLocation"
            view.rightCalloutAccessoryView = UIButton(type: .close)
            view.rightCalloutAccessoryView?.largeContentTitle = "diselectLocation"
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control.largeContentTitle == "selectLocation" {
            print("selectLocation")
        } else if control.largeContentTitle == "diselectLocation" {
            print("diselectLocation")
        }
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
