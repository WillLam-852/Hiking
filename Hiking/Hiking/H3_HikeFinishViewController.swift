//
//  H3_HikeFinishViewController.swift
//  Hiking
//
//  Created by Will Lam on 23/11/2020.
//

import UIKit
import Charts
import TinyConstraints
import CoreLocation
import MapKit

class H3_HikeFinishViewController: UIViewController, ChartViewDelegate, MKMapViewDelegate {
    @IBOutlet weak var Pace: UILabel!
    @IBOutlet weak var Calories: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var oxygenSaturationLabel: UILabel!
    @IBOutlet weak var chartLineView: UIView!
    @IBOutlet weak var peakLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var currentRoute: Route? = nil
    
    @IBAction func saveButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Save Record?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default, handler: {
            [weak alert] _ in
                guard let alert = alert, let textField = alert.textFields?.first else { return }
            self.currentRoute?.name = textField.text ?? "Untitled"
            self.saveHikeRecordsDocument()
            self.performSegue(withIdentifier: "saveRecord", sender: self)
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
    
    @IBAction func pressedLeaveButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Leave without saving?", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Leave", style: .destructive, handler: {_ in 
            self.performSegue(withIdentifier: "saveRecord", sender: self)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    @IBOutlet weak var Physical: UITextView!
    var heartratearray:[Double]=[]
    var yValue:[ChartDataEntry] = []
    var distancevalue:Double?
    var CaloriesBurn:Double?
    var AvgPace:Double?
    var count:Int?
    var age:Int?=0
    var starttime:Date?
    var oxygenSaturation:Double?
    var averageBPM: Double?
    var peak: Double?
    var userLocationsCoordinates: [CLLocationCoordinate2D] = []
    
    lazy var lineChartView:LineChartView = {
        let chartView=LineChartView()
        chartView.backgroundColor = .white
        
        chartView.rightAxis.enabled=false
        let yAxis = chartView.leftAxis
        yAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        yAxis.axisMinimum = 0
        
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.labelFont = .boldSystemFont(ofSize: 14)
        yAxis.labelTextColor = .black
        yAxis.axisLineColor = .black
        return chartView
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        let polyline = MKPolyline(coordinates: self.userLocationsCoordinates, count: self.userLocationsCoordinates.count)
        self.mapView.addOverlay(polyline)
        
        let sP = CLLocation(latitude: self.userLocationsCoordinates.first!.latitude, longitude: self.userLocationsCoordinates.first!.longitude)
        let eP = CLLocation(latitude: self.userLocationsCoordinates.last!.latitude, longitude: self.userLocationsCoordinates.last!.longitude)
        let zoom = eP.distance(from: sP) * 2.0
        
        let midPoint = CLLocationCoordinate2D(latitude: (self.userLocationsCoordinates.first!.latitude+self.userLocationsCoordinates.last!.latitude)*0.5, longitude: (self.userLocationsCoordinates.first!.longitude+self.userLocationsCoordinates.last!.longitude)*0.5)
        let region = MKCoordinateRegion(center: midPoint, latitudinalMeters: zoom, longitudinalMeters: zoom)
        self.mapView.setRegion(region, animated: false)
        
        self.chartLineView.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: chartLineView)
        lineChartView.heightToWidth(of: chartLineView)
        
        setData()
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
        peakLabel.text = String(format: "%.2f", peak!) + " m"
        
        let sumArray=heartratearray.reduce(0, +)
        averageBPM = sumArray / Double(heartratearray.count)
        
        if averageBPM!>(220-Double(self.age!))*0.9{
            Physical.text="Estimated physical fitness: weak => need to take more exercise"
        }
        else if averageBPM!>(220-Double(self.age!))*0.8{
            Physical.text="Estimated physical fitness: sightly weak => need to take more exercise"
        }
        else if averageBPM!>(220-Double(self.age!))*0.7{
            Physical.text="Estimated physical fitness: healthy => still need to take more exercise"
        }
        else if averageBPM!>(220-Double(self.age!))*0.6{
            Physical.text="Estimated physical fitness: good => still need to take more exercise"
        }
        else {
            Physical.text="Estimated physical fitness: excellent => might need to take more exercise"
        }
        bpmLabel.text = String(format: "%.2f", averageBPM!) + " count/min"
        oxygenSaturationLabel.text=String(format: "%.2f", Double(oxygenSaturation!)) + " %"
        
        
        var midwayPointsArray: [MapPoint] = []
        for n in 0 ..< userLocationsCoordinates.count {
            midwayPointsArray.append(MapPoint(name: String(n), type: .selfDefined, coordinate: userLocationsCoordinates[n], orderNumber: n))
        }
    
        currentRoute = Route(name: "Untitled", description: "", distance: distancevalue!, expectedTime: Double(count!)/3600, peak: peak!, difficulty: 3, bookmarked: 0, district: [], startPoint: userLocationsCoordinates.first!, endPoint: userLocationsCoordinates.last!, midwayPoints: midwayPointsArray)
        
        // Do any additional setup after loading the view.
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print(entry)
    }
    
    func setData(){
        let set1 = LineChartDataSet(entries: yValue, label: "Heart Rate")
        set1.mode = .cubicBezier
        set1.drawCirclesEnabled = false
        set1.lineWidth=3
        set1.setColor(.red)
        
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        lineChartView.data = data
    }
    
    
    private func saveHikeRecordsDocument() {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let hikeRecordsDocumentURL = dirPaths[0].appendingPathComponent("hikeRecords.txt")
        let hikeRecordsDocument = HikeRecordsDocument(fileURL: hikeRecordsDocumentURL)
        currentUser.userHikeRecord.append(HikeRecord(routeReference: currentRoute!, recordedRouteName: currentRoute!.name, recordedDistance: distancevalue!, recordDate: starttime!, recordedTime: Double(count!/3600), recordedAveragePace: AvgPace!, recordedAverageBPM: averageBPM!, recordedPeak: peak!))
        hikeRecordsDocument.hikeRecords = currentUser.userHikeRecord
        hikeRecordsDocument.save(to: hikeRecordsDocumentURL, for: .forOverwriting, completionHandler: {(success:Bool) in
            if !success{
                print("Failed to update Hike Records Document")
            }else{
                print("Hike Records Document updated")
            }
        })
    }

    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = .blue
        renderer.lineWidth = 4.0
        return renderer
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



