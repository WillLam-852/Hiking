//
//  A1_HomeViewController.swift
//  Hiking
//
//  Created by Will Lam on 4/11/2020.
//

import UIKit
import CoreLocation
import MapKit

class A1_HomeViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var weather_TextView: UITextView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var goal_Label: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var userRegion: MKCoordinateRegion = MKCoordinateRegion()
    
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
    
    @IBAction func pressedBookmarkButton(_ sender: UIButton) {
    }
    
    @IBAction func pressedStartButton(_ sender: UIButton) {
        mapView.setRegion(userRegion, animated: true)
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        let userCenter = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        userRegion = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
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
