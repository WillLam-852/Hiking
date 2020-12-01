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
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var checkbox_toilet: UIButton!
    @IBOutlet weak var checkbox_campsite: UIButton!
    @IBOutlet weak var checkbox_viewingpoint: UIButton!
    @IBOutlet weak var checkbox_busstop: UIButton!
    @IBOutlet weak var checkbox_pier: UIButton!
    @IBOutlet weak var checkbox_beach: UIButton!
    @IBOutlet weak var checkbox_sittingoutarea: UIButton!
    @IBOutlet weak var checkbox_pavilion: UIButton!
    @IBOutlet weak var checkbox_sunrise: UIButton!
    @IBOutlet weak var checkbox_stargazing: UIButton!
    
    var currentPlacemark: CLPlacemark?
    var selectedPin: MKPlacemark? = nil
    var selectedPinCoordinate: CLLocationCoordinate2D? = nil
    var locationManager: CLLocationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var annotation_StartPoint: MKPointAnnotation? = nil
    var annotation_EndPoint: MKPointAnnotation? = nil
    var annotation_MidwayPoint: [(MKPointAnnotation, Int?)] = []
    var currentRoute: Route? = nil
    var checkboxsValue = [true, true, true, true, true, true, true, true, true, true]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        doneButton.isEnabled = false
        title = "HIKE"
        navigationController?.title = "Hike"
        
        for checkbox in [checkbox_toilet, checkbox_campsite, checkbox_viewingpoint, checkbox_busstop, checkbox_pier, checkbox_beach, checkbox_sittingoutarea, checkbox_pavilion, checkbox_sunrise, checkbox_stargazing] {
            checkbox?.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
        }
        
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
            } else if view.annotation?.title == "ViewingPoint" {
                view.glyphImage = UIImage(systemName: "camera.fill")
            } else if view.annotation?.title == "BusStop" {
                view.glyphImage = UIImage(systemName: "bus.doubledecker")
            } else if view.annotation?.title == "Pier" {
                view.glyphImage = UIImage(named: "Pier")
            } else if view.annotation?.title == "Beach" {
                view.glyphImage = UIImage(named: "Beach")
            } else if view.annotation?.title == "SittingOutArea" {
                view.glyphImage = UIImage(named: "SittingOutArea")
            } else if view.annotation?.title == "Pavilion" {
                view.glyphImage = UIImage(named: "Pavilion")
            } else if view.annotation?.title == "Sunrise" {
                view.glyphImage = UIImage(systemName: "sunrise.fill")
            } else if view.annotation?.title == "Sunset" {
                view.glyphImage = UIImage(systemName: "sunset.fill")
            } else if view.annotation?.title == "Stargazing" {
                view.glyphImage = UIImage(systemName: "moon.stars.fill")
            } else if view.annotation?.title == "SelfDefined" {
                view.glyphImage = UIImage(systemName: "mappin.and.ellipse")
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
            self.doneButton.isEnabled = true
        } else {
            self.doneButton.isEnabled = false
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
    
    @IBAction func pressedDoneButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add New Route", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {
            [weak alert] _ in
                guard let alert = alert, let textField = alert.textFields?.first else { return }
            self.currentRoute?.name = textField.text ?? "Unnamed"
            routeList.append(self.currentRoute!)
            
            
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        alert.addTextField() {
            textField in
            textField.placeholder = "Route Name"
        }
        self.present(alert, animated: true)
    }
    
    @IBAction func pressedCheckbox_toilet(_ sender: UIButton) {
        let location = "Toilet"
        if !checkboxsValue[0] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[0] = !checkboxsValue[0]
    }
    
    @IBAction func pressedCheckbox_campsite(_ sender: UIButton) {
        let location = "Campsite"
        if !checkboxsValue[1] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[1] = !checkboxsValue[1]
    }
    
    @IBAction func pressedCheckbox_viewingpoint(_ sender: UIButton) {
        let location = "ViewingPoint"
        if !checkboxsValue[2] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[2] = !checkboxsValue[2]
    }
    
    @IBAction func pressedCheckbox_busstop(_ sender: UIButton) {
        let location = "BusStop"
        if !checkboxsValue[3] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[3] = !checkboxsValue[3]
    }
    
    @IBAction func pressedCheckbox_pier(_ sender: UIButton) {
        let location = "Pier"
        if !checkboxsValue[4] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[4] = !checkboxsValue[4]
    }
    
    @IBAction func pressedCheckbox_beach(_ sender: UIButton) {
        let location = "Beach"
        if !checkboxsValue[5] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[5] = !checkboxsValue[5]
    }
    
    @IBAction func pressedCheckbox_sittingoutarea(_ sender: UIButton) {
        let location = "SittingOutArea"
        if !checkboxsValue[6] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[6] = !checkboxsValue[6]
    }
    
    @IBAction func pressedCheckbox_pavilion(_ sender: UIButton) {
        let location = "Pavilion"
        if !checkboxsValue[7] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[7] = !checkboxsValue[7]
    }
    
    @IBAction func pressedCheckbox_sunrise(_ sender: UIButton) {
        let location = "Sunrise"
        if !checkboxsValue[8] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[8] = !checkboxsValue[8]
    }
    
    @IBAction func pressedCheckbox_stargazing(_ sender: UIButton) {
        let location = "Stargazing"
        if !checkboxsValue[9] {
            sender.setImage(UIImage(named: "Checkbox_checked"), for: .normal)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = location
            request.region = self.mapView.region
            let search = MKLocalSearch(request: request)
            search.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = location
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        } else {
            sender.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
            self.mapView.removeAnnotations(self.mapView.annotations.filter({$0.title == location}))
        }
        self.mapView.reloadInputViews()
        checkboxsValue[9] = !checkboxsValue[9]
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
