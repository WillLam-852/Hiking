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
    var selectedPinCoordinate: CLLocationCoordinate2D? = nil
    var locationManager: CLLocationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var annotation_StartPoint: MKPointAnnotation? = nil
    var annotation_EndPoint: MKPointAnnotation? = nil
    var annotation_MidwayPoint: [(MKPointAnnotation, Int?)] = []
    var currentRoute: Route? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.showsUserLocation = true
        mapView.delegate = self
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
        longPress.minimumPressDuration = 0.3
        mapView.addGestureRecognizer(longPress)
    }
    
    @objc func addAnnotation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinates = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            selectedPinCoordinate = newCoordinates

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
            })
        }
    }
    
    
    private func routeMaking(sourceAddress: MKMapItem, destinationAddress: MKMapItem) {
        let request = MKDirections.Request()
        request.source = sourceAddress
        request.destination = destinationAddress
        request.requestsAlternateRoutes = false
        
        let directions = MKDirections(request: request)
        directions.calculate() {
            (response, error) in
            if let res = response {
                for r in res.routes {
                    self.mapView.addOverlay(r.polyline, level: MKOverlayLevel.aboveRoads)
                    for step in r.steps {
                        print(step.instructions)
                    }
                }
            }
        }
    }
    
    
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
            if view.annotation?.title == "Start Point" {
                view.glyphImage = UIImage(systemName: "play.fill")
            } else if view.annotation?.title == "End Point" {
                view.glyphImage = UIImage(systemName: "stop.fill")
            } else if view.annotation?.title == "Toilet" {
                view.glyphImage = UIImage(named: "Toilet")
            } else if view.annotation?.title == "Campsite" {
                view.glyphImage = UIImage(named: "Campsite")
            }
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control.largeContentTitle == "selectLocation" {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Start Point", style: UIAlertAction.Style.default, handler: { action in
                self.addMapPoint(0)
            }))
            alert.addAction(UIAlertAction(title: "End Point", style: UIAlertAction.Style.default, handler: { action in
                self.addMapPoint(11)
            }))
            alert.addAction(UIAlertAction(title: "Midway Point", style: UIAlertAction.Style.default, handler: { action in
                let alertMidwayPoint = UIAlertController(title: "Which number is this midway point? (1-10)", message: nil, preferredStyle: .alert)
                alertMidwayPoint.addTextField() {
                    textField in
                    textField.placeholder = "Midway point number"
                }
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) {
                    [weak alertMidwayPoint] _ in
                        guard let alertMidwayPoint = alertMidwayPoint, let textField = alertMidwayPoint.textFields?.first else { return }
                    self.addMapPoint(Int(textField.text!)!)
                }
                alertMidwayPoint.addAction(confirmAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertMidwayPoint.addAction(cancelAction)
                self.present(alertMidwayPoint, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Delete Point", style: UIAlertAction.Style.destructive, handler: { action in
                self.deleteMapPoint()
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    // MARK: - Private Functions
    
    private func addMapPoint(_ mode: Int) {
        if let sPC = selectedPinCoordinate {
            if mode == 0 {
                // Add Start Point
                if annotation_StartPoint != nil {
                    self.mapView.removeAnnotation(annotation_StartPoint!)
                } else {
                    annotation_StartPoint = MKPointAnnotation()
                    annotation_StartPoint!.title = "Start Point"
                }
                annotation_StartPoint!.coordinate = sPC
                self.mapView.removeAnnotations(self.mapView.selectedAnnotations)
                self.mapView.addAnnotation(annotation_StartPoint!)
            } else if mode == 11 {
                // Add End Point
                if annotation_EndPoint != nil {
                    self.mapView.removeAnnotation(annotation_EndPoint!)
                } else {
                    annotation_EndPoint = MKPointAnnotation()
                    annotation_EndPoint!.title = "End Point"
                }
                annotation_EndPoint!.coordinate = sPC
                self.mapView.removeAnnotations(self.mapView.selectedAnnotations)
                self.mapView.addAnnotation(annotation_EndPoint!)
            } else {
                // Add Midway Point
                let new_annotation_MidwayPoint = MKPointAnnotation()
                new_annotation_MidwayPoint.coordinate = sPC
                new_annotation_MidwayPoint.title = "Midway Point \(mode)"
                self.annotation_MidwayPoint.append((new_annotation_MidwayPoint, mode))
                self.mapView.removeAnnotations(self.mapView.selectedAnnotations)
                self.mapView.addAnnotation(new_annotation_MidwayPoint)
            }
            self.recordCurrentRoute()
        }
    }
    
    
    private func deleteMapPoint() {
        let coord = self.mapView.selectedAnnotations[0].coordinate
        self.mapView.removeAnnotations(self.mapView.selectedAnnotations)
        self.annotation_MidwayPoint.removeAll(where: {
            $0.0.coordinate.latitude == coord.latitude && $0.0.coordinate.longitude == coord.longitude
        })
        self.recordCurrentRoute()
    }
    
    
    private func recordCurrentRoute() {
        if annotation_StartPoint != nil && annotation_EndPoint != nil {
            // MARK: - TODO: Calculate Distance, Expected Time, Peak...
            var midwayPoint: [MapPoint] = []
            for mP in self.annotation_MidwayPoint {
                midwayPoint.append(MapPoint(name: "Midway Point \(String(mP.1!))", type: .selfDefined, coordinate: mP.0.coordinate, orderNumber: mP.1!))
            }
            midwayPoint.sort() {
                $0.orderNumber < $1.orderNumber
            }
            self.currentRoute = Route(name: "Unnamed", description: "", distance: 0, expectedTime: 0, peak: 0, difficulty: 1, bookmarked: 0, district: [], startPoint: annotation_StartPoint!.coordinate, endPoint: annotation_EndPoint!.coordinate, midwayPoints: midwayPoint)
            self.showMapRoute()
        }
    }
    
    
    private func showMapRoute() {
        self.mapView.removeOverlays(self.mapView.overlays)
        if self.currentRoute?.midwayPoints.count == 0 {
            self.fetchNextRoute(from: currentRoute!.startPoint, to: currentRoute!.endPoint)
        } else {
            let tempRoute = self.currentRoute
            var nextMidwayPoint = tempRoute?.midwayPoints.removeFirst()
            self.fetchNextRoute(from: currentRoute!.startPoint, to: nextMidwayPoint!.coordinate)
            while (tempRoute?.midwayPoints.count)! > 0 {
                self.fetchNextRoute(from: nextMidwayPoint!.coordinate, to: (tempRoute?.midwayPoints.first?.coordinate)!)
                nextMidwayPoint = tempRoute?.midwayPoints.removeFirst()
            }
            self.fetchNextRoute(from: nextMidwayPoint!.coordinate, to: currentRoute!.endPoint)
        }
        
        let sP = CLLocation(latitude: self.currentRoute!.startPoint.latitude, longitude: self.currentRoute!.startPoint.longitude)
        let eP = CLLocation(latitude: self.currentRoute!.endPoint.latitude, longitude: self.currentRoute!.endPoint.longitude)
        let zoom = eP.distance(from: sP) * 2.0
        
        let midPoint = CLLocationCoordinate2D(latitude: (self.currentRoute!.startPoint.latitude+self.currentRoute!.endPoint.latitude)*0.5, longitude: (self.currentRoute!.startPoint.longitude+self.currentRoute!.endPoint.longitude)*0.5)
        let region = MKCoordinateRegion(center: midPoint, latitudinalMeters: zoom, longitudinalMeters: zoom)
        self.mapView.setRegion(region, animated: true)
    }
    
    
    private func fetchNextRoute(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) {
        
        let request = MKDirections.Request()
        
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let direction = MKDirections(request: request)
        direction.calculate() {
            (response, error) in
            if let r = response, r.routes.count > 0 {
                self.mapView.addOverlay(r.routes[0].polyline, level: MKOverlayLevel.aboveRoads)
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func pressedClearButton(_ sender: UIButton) {
        self.mapView.removeAnnotations(self.mapView.annotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        self.currentRoute = nil
    }
}


// MARK: - Extension

extension A3_HomeRouteDrawViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        selectedPin = placemark // cache the pin
        selectedPinCoordinate = placemark.coordinate
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
