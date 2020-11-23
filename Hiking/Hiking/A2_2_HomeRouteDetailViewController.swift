//
//  A2_2_HomeRouteDetailViewController.swift
//  Hiking
//
//  Created by Will Lam on 18/11/2020.
//

import UIKit
import MapKit
import CoreLocation

class A2_2_HomeRouteDetailViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    var currentRoute: Route?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var expectedTimeLabel: UILabel!
    @IBOutlet weak var peakLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var districtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let r = currentRoute {
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
    }
    
    // MARK: - Actions
    
    @IBAction func pressedStart(_ sender: Any) {
        
    }
    
    
    // MARK: - Private Functions
    
    private func showMapRoute() {
        if let r = currentRoute {
            let request = MKDirections.Request()
            
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: r.startPoint))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: r.endPoint))
            request.requestsAlternateRoutes = false
            request.transportType = .walking
            
            let direction = MKDirections(request: request)
            direction.calculate() {
                (response, error) in
                if let r = response, r.routes.count > 0 {
                    self.mapView.removeOverlays(self.mapView.overlays)
                    self.mapView.addOverlay(r.routes[0].polyline, level: MKOverlayLevel.aboveRoads)
                }
            }
            
            let sP = CLLocation(latitude: r.startPoint.latitude, longitude: r.startPoint.longitude)
            let eP = CLLocation(latitude: r.endPoint.latitude, longitude: r.endPoint.longitude)
            let zoom = eP.distance(from: sP) * 2.0
            
            let midPoint = CLLocationCoordinate2D(latitude: (r.startPoint.latitude+r.endPoint.latitude)*0.5, longitude: (r.startPoint.longitude+r.endPoint.longitude)*0.5)
            let region = MKCoordinateRegion(center: midPoint, latitudinalMeters: zoom, longitudinalMeters: zoom)
            mapView.setRegion(region, animated: true)
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
                        self.mapView.addAnnotation(annotation_Toilet)
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
                        self.mapView.addAnnotation(annotation_Campsite)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
