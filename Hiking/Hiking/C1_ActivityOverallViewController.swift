//
//  C1_ActivityOverallViewController.swift
//  Hiking
//
//  Created by Will Lam on 4/11/2020.
//

import UIKit
import MapKit

class C1_ActivityOverallViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var noOfHikesLabel: UILabel!
    @IBOutlet weak var averageDistanceLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        var totalDistance = 0.0
        var totalTime = 0.0
        for i in currentUser.userHikeRecord {
            totalDistance += i.recordedDistance
            totalTime += i.recordedTime
            self.showMapRoute(route: i.routeReference ?? routeA)
        }
        
        let totalDistance_attributedText = NSMutableAttributedString(string: String(format: "%.2f", totalDistance), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)])
        totalDistance_attributedText.append(NSAttributedString(string: " km", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)]))
        let averageDistance_attributedText = NSMutableAttributedString(string: String(format: "%.2f", totalDistance/Double(currentUser.userHikeRecord.count)), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)])
        averageDistance_attributedText.append(NSAttributedString(string: " km", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]))
        let averagePace_attributedText = NSMutableAttributedString(string: String(format: "%.2f", totalDistance/totalTime), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 25)])
        averagePace_attributedText.append(NSAttributedString(string: " km/hr", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]))
        
        totalDistanceLabel.attributedText = totalDistance_attributedText
        noOfHikesLabel.text = String(currentUser.userHikeRecord.count)
        averageDistanceLabel.attributedText = averageDistance_attributedText
        averagePaceLabel.attributedText = averagePace_attributedText
    }
    

    // MARK: - Private Functions
    
    private func showMapRoute(route: Route) {
        self.mapView.removeOverlays(self.mapView.overlays)
        if route.midwayPoints.count == 0 {
            self.fetchNextRoute(from: route.startPoint, to: route.endPoint)
        } else {
            let tempRoute = Route(name: route.name, description: route.description, distance: route.distance, expectedTime: route.expectedTime, peak: route.peak, difficulty: route.difficulty, bookmarked: route.bookmarked, district: route.district, startPoint: route.startPoint, endPoint: route.endPoint, midwayPoints: route.midwayPoints)
            var nextMidwayPoint = tempRoute.midwayPoints.removeFirst()
            self.fetchNextRoute(from: route.startPoint, to: nextMidwayPoint.coordinate)
            while (tempRoute.midwayPoints.count) > 0 {
                print("tempRoute.midwayPoints.count", tempRoute.midwayPoints.count)
                print("route.midwayPoints.count", route.midwayPoints.count)
                self.fetchNextRoute(from: nextMidwayPoint.coordinate, to: (tempRoute.midwayPoints.first?.coordinate)!)
                nextMidwayPoint = tempRoute.midwayPoints.removeFirst()
            }
            self.fetchNextRoute(from: nextMidwayPoint.coordinate, to: route.endPoint)
        }
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
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
