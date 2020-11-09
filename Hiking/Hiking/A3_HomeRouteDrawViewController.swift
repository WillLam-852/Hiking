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

class A3_HomeRouteDrawViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var place_textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
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
        locationManager.allowsBackgroundLocationUpdates = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
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
    
    
    // MARK: - Actions

    @IBAction func pressedSearchButton(_ sender: UIButton) {
        if let address = place_textField.text {
            CLGeocoder().geocodeAddressString(address) {
                (placemarks, error) in
                if error != nil {
                    print("Geo failed with error: \(error!.localizedDescription)")
                } else if let marks = placemarks, marks.count > 0 {
                    let placemark = marks[0]
                    if let location = placemark.location {
                        CLGeocoder().reverseGeocodeLocation(location) {
                            (p, e) in
                            if e != nil {
                                print("Reverse geo failed with error: \(error!.localizedDescription)")
                            } else if let m = p, m.count > 0 {
                                let pm = m[0] as CLPlacemark
                                self.currentPlacemark = pm
                                if let add = pm.postalAddress {
                                    self.currentPostalAddress = add
                                }
                            }
                        }
                    }

                }
            }
        }
        
        if let pm = currentPlacemark, let loc = pm.location {
            let searchCenter = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
            let searchRegion = MKCoordinateRegion(center: searchCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            mapView.setRegion(searchRegion, animated: true)
        }
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation:CLLocation = locations[0] as CLLocation
        let userCenter = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let searchRegion = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(searchRegion, animated: true)

        print("Location changed! \(locations.count) location(s) detected")
        for item in locations {
            print("\(item)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
}
