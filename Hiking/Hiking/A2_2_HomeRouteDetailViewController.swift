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
    
    @IBAction func pressedStart(_ sender: Any) {
        
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
            
            let request_toilet = MKLocalSearch.Request()
            request_toilet.naturalLanguageQuery = "Toilet"
            request_toilet.region = self.mapView.region
            let search_toilet = MKLocalSearch(request: request_toilet)
            search_toilet.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation_Toilet = MKPointAnnotation()
                        annotation_Toilet.coordinate = item.placemark.coordinate
                        annotation_Toilet.title = "Toilet"
//                        self.mapView.addAnnotation(annotation_Toilet)
                    }
                }
            }
            
            let request_campsite = MKLocalSearch.Request()
            request_campsite.naturalLanguageQuery = "Campsite"
            request_campsite.region = self.mapView.region
            let search_campsite = MKLocalSearch(request: request_campsite)
            search_campsite.start() {
                (response, error) in
                if error != nil {
                    print("Error in search: \(error!.localizedDescription)")
                } else if response!.mapItems.count > 0 {
                    for item in response!.mapItems {
                        let annotation_Campsite = MKPointAnnotation()
                        annotation_Campsite.coordinate = item.placemark.coordinate
                        annotation_Campsite.title = "Campsite"
//                        self.mapView.addAnnotation(annotation_Campsite)
                    }
                }
            }
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
