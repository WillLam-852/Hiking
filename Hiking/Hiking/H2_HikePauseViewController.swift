//
//  H2_HikePauseViewController.swift
//  Hiking
//
//  Created by Will Lam on 23/11/2020.
//

import UIKit
import Charts
import MapKit
import CoreLocation
import CoreServices

class H2_HikePauseViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var Pace: UILabel!
    @IBOutlet weak var Calories: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var heartrate: UILabel!
    @IBOutlet weak var OxygenSaturationLabel: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var elevationLabel: UILabel!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var checkpointLabel: UILabel!
    
    var starttime:Date!
    var weight:Double?
    var heartratevalue:Int?
    var distancevalue:Double?
    var CaloriesBurn:Double?
    var AvgPace:Double?
    var doneloadtime:Date?
    var interval1:Int?=0
    var count:Int?
    var heartratearray:[Double]=[]
    var yValue:[ChartDataEntry] = []
    var age:Int?=0
    var oxygenSaturation:Double?
    var elevation: Double?
    var peak: Double?
    var targetDistance: Double?
    var defaultRoute: Route?
  
    var locationManager: CLLocationManager = CLLocationManager()
    var userRegion: MKCoordinateRegion = MKCoordinateRegion()
    var alertController: UIAlertController?
    
    var userLocationsCoordinates: [CLLocationCoordinate2D] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heartrate.text=String("\(heartratevalue!) count/min")
        
        let distance_attributedText = NSMutableAttributedString(string: String(format: "%.2f", distancevalue!) + " m", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)])
        if self.targetDistance != nil {
            distance_attributedText.append(NSAttributedString(string: " / \(String(describing: self.targetDistance)) km", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12)]))
        }
        self.distance.attributedText = distance_attributedText
        
        distance.text=String("\(distancevalue!) m")
        Calories.text=String("\(CaloriesBurn!) cal")
        Pace.text=String(format: "%.2f", AvgPace!*0.036) + " km/hr"
        var timeText = ""
        if self.count!/3600 < 10 {
            timeText += "0" + String(Int(self.count!/3600)) + ":"
        } else {
            timeText += String(Int(self.count!/3600)) + ":"
        }
        if self.count!/60 < 10 {
            timeText += "0" + String(Int(self.count!/60)) + ":"
        } else {
            timeText += String(Int(self.count!/60)) + ":"
        }
        if self.count!%60 < 10 {
            timeText += "0" + String(Int(self.count!%60))
        } else {
            timeText += String(Int(self.count!%60))
        }
        self.time.text=timeText
        doneloadtime = Date()
        OxygenSaturationLabel.text=String(format: "%.2f", oxygenSaturation!) + " %"
        elevationLabel.text = String(format: "%.2f", elevation!) + " m"
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }

        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="return"{
            let target = segue.destination as! H1_HikeOnProgressViewController
            target.userLocationsCoordinates = self.userLocationsCoordinates
            target.doneload=true
            target.starttime=starttime
            target.weight=weight
            target.doneloadDate=doneloadtime
            target.interval1=interval1
            target.count=count
            target.elevation=elevation!
            target.peak=peak!
            target.targetDistance = targetDistance
            target.defaultRoute = defaultRoute
        }
        if segue.identifier=="showFinish"{
            let target = segue.destination as! H3_HikeFinishViewController
            target.userLocationsCoordinates = self.userLocationsCoordinates
            target.count=count
            target.yValue=yValue
            target.AvgPace=AvgPace
            target.CaloriesBurn=CaloriesBurn
            target.distancevalue=distancevalue
            target.age=age
            target.starttime=starttime
            target.heartratearray=heartratearray
            target.oxygenSaturation=oxygenSaturation
            target.peak=peak
        }
    }
    
    
    @IBAction func pressedCameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showImgPicker(type: .camera)
        } else {
            showErrorAlert(title: "Error", message: "Camera is not available")
        }
    }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        let userCenter = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        self.userLocationsCoordinates.append(userCenter)
        print("self.userLocationsCoordinates: ", self.userLocationsCoordinates.count)
        DispatchQueue.main.async {
            let polyline = MKPolyline(coordinates: self.userLocationsCoordinates, count: self.userLocationsCoordinates.count)
            self.mapView.addOverlay(polyline)
        }
            
        userRegion = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(userRegion, animated: false)
        
        for item in locations {
            print("\(item)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let img = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        UIImageWriteToSavedPhotosAlbum(img, self, #selector(H1_HikeOnProgressViewController.image(image:didFinishSavingWithError:contextInfo:)), nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    func showImgPicker(type: UIImagePickerController.SourceType) {
        let imgPicker = UIImagePickerController()
        imgPicker.sourceType = type
        imgPicker.mediaTypes = [kUTTypeImage as String]
        imgPicker.allowsEditing = false
        imgPicker.delegate = self
        self.present(imgPicker, animated: true, completion: nil)
    }
    
    func showErrorAlert(title t: String, message m: String) {
        if let ac = alertController {
            ac.title = t
            ac.message = m
        } else {
            alertController = UIAlertController(title: t, message: m, preferredStyle: .alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController!.addAction(cancel)
        }
        self.present(alertController!, animated: true, completion: nil)
    }
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        if error != nil {
            showErrorAlert(title: "Error", message: "Failed to save image")
        }
    }
}


extension Date {

    static func `_`(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}

