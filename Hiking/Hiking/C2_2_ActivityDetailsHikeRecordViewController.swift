//
//  C2_2_ActivityDetailsHikeRecordViewController.swift
//  Hiking
//
//  Created by Will Lam on 23/11/2020.
//

import UIKit
import MapKit

class C2_2_ActivityDetailsHikeRecordViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var peakLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    
    var currentHikeRecord: HikeRecord? = nil
    var currentRoute: Route? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let hr = currentHikeRecord {
            let dF = DateFormatter()
            dF.dateFormat = "d MMM yyyy"
            dateLabel.text = dF.string(from: hr.recordedDate)
            distanceLabel.text = String(hr.recordedDistance) + " km"
            timeLabel.text = String(hr.recordedTime) + " hour"
            peakLabel.text = String(hr.recordedPeak) + " m"
            paceLabel.text = String(hr.recordedAveragePace) + " km/hr"
            bpmLabel.text = String(hr.recordedAverageBPM)
            currentRoute = hr.routeReference
        }
        
        mapView.delegate = self
        self.showMapRoute()
        self.showAnnotations()
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
    
    
    // MARK: - Actions
    
    @IBAction func pressedEditButton(_ sender: UIButton) {
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
