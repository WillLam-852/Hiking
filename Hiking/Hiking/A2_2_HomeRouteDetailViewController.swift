//
//  A2_2_HomeRouteDetailViewController.swift
//  Hiking
//
//  Created by Will Lam on 18/11/2020.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class A2_2_HomeRouteDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var currentRoute: Route?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var expectedTimeLabel: UILabel!
    @IBOutlet weak var peakLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    @IBOutlet weak var audioPlayButton: UIButton!
    @IBOutlet weak var audioPauseButton: UIButton!
    
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
    
    var checkboxsValue = [true, true, true, true, true, true, true, true, true, true]
    var audioPlayer = AVAudioPlayer()
    
    @IBAction func pressedAudioPlayButton(_ sender: UIButton) {
        audioPlayer.play()
        audioPlayButton.isHidden = true
        audioPauseButton.isHidden = false
    }
    
    @IBAction func pressedAudioPauseButton(_ sender: UIButton) {
        audioPlayer.pause()
        audioPlayButton.isHidden = false
        audioPauseButton.isHidden = true
    }
    
    @IBAction func pressedStartButton(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startRoutingSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for checkbox in [checkbox_toilet, checkbox_campsite, checkbox_viewingpoint, checkbox_busstop, checkbox_pier, checkbox_beach, checkbox_sittingoutarea, checkbox_pavilion, checkbox_sunrise, checkbox_stargazing] {
            checkbox?.setImage(UIImage(named: "Checkbox_unchecked"), for: .normal)
        }

        // Do any additional setup after loading the view.
        if let r = currentRoute {
            title = r.name
            descriptionTextField.text = r.description
            distanceLabel.text = String(r.distance) + " km"
            expectedTimeLabel.text = String(r.expectedTime) + " hour"
            peakLabel.text = String(r.peak) + " m"
            difficultyLabel.text = String(r.difficulty) + " star(s)"
            districtLabel.text = r.district.joined(separator: ", ")
        }
        
        mapView.delegate = self
        self.showMapRoute()
        self.showAnnotations()
        
        audioPlayButton.isHidden = false
        audioPauseButton.isHidden = true
        
        let sound = Bundle.main.path(forResource: "Voice Guide of Bride's Pool", ofType: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch{
            print(error)
        }
        
        var frame = self.descriptionTextField.frame
        frame.size.height = self.descriptionTextField.contentSize.height
        self.descriptionTextField.frame = frame
    }
    
    // MARK: - Actions
    
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

    
    // MARK: - Private Functions
    
    private func showMapRoute() {
        self.mapView.removeOverlays(self.mapView.overlays)
        if self.currentRoute?.midwayPoints.count == 0 {
            self.fetchNextRoute(from: currentRoute!.startPoint, to: currentRoute!.endPoint)
        } else {
            let tempRoute = Route(name: currentRoute!.name, description: currentRoute!.description, distance: currentRoute!.distance, expectedTime: currentRoute!.expectedTime, peak: currentRoute!.peak, difficulty: currentRoute!.difficulty, bookmarked: currentRoute!.bookmarked, district: currentRoute!.district, startPoint: currentRoute!.startPoint, endPoint: currentRoute!.endPoint, midwayPoints: currentRoute!.midwayPoints)
            var nextMidwayPoint = tempRoute.midwayPoints.removeFirst()
            self.fetchNextRoute(from: currentRoute!.startPoint, to: nextMidwayPoint.coordinate)
            while tempRoute.midwayPoints.count > 0 {
                self.fetchNextRoute(from: nextMidwayPoint.coordinate, to: (tempRoute.midwayPoints.first?.coordinate)!)
                nextMidwayPoint = tempRoute.midwayPoints.removeFirst()
            }
            self.fetchNextRoute(from: nextMidwayPoint.coordinate, to: currentRoute!.endPoint)
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
    
    private func showAnnotations() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        if let r = currentRoute {
            
            let annotation_StartPoint = MKPointAnnotation()
            annotation_StartPoint.coordinate = r.startPoint
            annotation_StartPoint.title = "Start Point"
            
            let annotation_EndPoint = MKPointAnnotation()
            annotation_EndPoint.coordinate = r.endPoint
            annotation_EndPoint.title = "End Point"
            
            self.mapView.addAnnotations([annotation_StartPoint, annotation_EndPoint])
        }
    }
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myMarker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
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
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startRoutingSegue" {
            let target = segue.destination as! H1_HikeOnProgressViewController
            target.targetDistance = currentRoute!.distance
            target.defaultRoute = currentRoute!
        }
    }

}
