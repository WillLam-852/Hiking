//
//  H1_HikeOnProgressViewController.swift
//  Hiking
//
//  Created by Will Lam on 23/11/2020.
//

import UIKit
import CoreLocation
import CoreServices
import MapKit
import HealthKit
import Charts
import TinyConstraints

class H1_HikeOnProgressViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var OxygenSaturation: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var Calories: UILabel!
    @IBOutlet weak var PauseButton: UIButton!
    
    var userLocationsCoordinates: [CLLocationCoordinate2D] = []
    var elevation: Double = 0.0
    var peak: Double = 0.0
    var targetDistance: Double? = nil
    var defaultRoute: Route?
    var totalDistanceValue: Double?
    
    
    // MARK: - Actions
    
    @IBAction func pressedPauseButton(_ sender: UIButton) {
        pauseMockData()
    }
    
    @IBAction func pressedMusicButton(_ sender: UIButton) {
        
    }
    
    @IBAction func pressedCameraButton(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showImgPicker(type: .camera)
        } else {
            showErrorAlert(title: "Error", message: "Camera is not available")
        }
    }

    
    var doneload = false
    let healthStore = HKHealthStore()
    var timer1: Timer?
    var timer2: Timer?
    var count:Int?=0
    var isPaused = true
    var starttime: Date?
    var weight:Double?=1
    
    var oxygenSaturation:Double?
    var yValue:[ChartDataEntry] = []
    var heartrate:Int?=0
    var distance:Double?=0
    var CaloriesBurn:Double?=0
    var AvgPace:Double?=0
    var doneloadDate:Date?
    var interval1:Int?=0
    var age:Int?=0
    var heartratearray:[Double]=[]
    var oxygenSaturationarray:[Double]=[]

    var locationManager: CLLocationManager = CLLocationManager()
    var userRegion: MKCoordinateRegion = MKCoordinateRegion()
    var alertController: UIAlertController?
    
    var currentLocation: CLLocation = CLLocation()
    var pavilionPoints:[CLLocation] = Array()
    var notifiedPavilionPoints:[CLLocation] = Array()
    var toiletPoints:[CLLocation] = Array()
    var notifiedToiletPoints:[CLLocation] = Array()
    var pathPoints:[CLLocation] = Array()
    
    var firstTime:Bool = true
    var totalDistance: Double = 0


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Navigation Bar and Tab Bar
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        if defaultRoute != nil {
            self.showMapRoute()
        }
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.setHidesBackButton(true, animated: false)
        if ((self.doneloadDate) != nil) {
            let interval=Date()-(self.doneloadDate)!
            interval1=Int(interval.second!)+interval1!
        }
        if HKHealthStore.isHealthDataAvailable() {
            let readDataTypes : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                                       HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
                                       HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                                       HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                                       HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                                       HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
                                       HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!]
            
            let writeDataTypes : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!,
                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.oxygenSaturation)!]
            if starttime != nil{
            }else{
                starttime=Date()
            }
            healthStore.requestAuthorization(toShare: writeDataTypes, read: readDataTypes) { (success, error) in
                if !success {
                    // Handle the error here.
                } else {
                    self.WritingWeight()
                    self.testHeartRateQuery()
                    self.testDistanceQuery()
                    self.ReadingWeight()
                    self.requestAgeAndUpdate()
                    self.testOxygenSaturtion()
                }
            }
            timer()
            startMockData()
            
        }
        
    }
    func requestAgeAndUpdate() {

        let dob = try? self.healthStore.dateOfBirthComponents()
        if dob != nil{
            let date1 = NSCalendar.current.date(from: (dob)!)
            let date2=Date()-date1!
            age=date2.month!/12
        }
        else{
            age=30
        }

        
        
    }
    
    func saveMockHeartRate(){
        let heartRate=HKSampleType.quantityType(forIdentifier: .heartRate)!
        let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
        let Heartrate = Int.random(in: 0...80)+100
        let heartRateQuantity=HKQuantity(unit: heartRateUnit, doubleValue: Double(Heartrate))
        let sample1 = HKQuantitySample(type: heartRate, quantity: heartRateQuantity, start: Date(), end: Date())
        healthStore.save(sample1){ success, error in
            if success{
                
            }
            else{
                
            }
        }}
    func saveMockOxygenSaturation(){
        let oxygenSaturation=HKSampleType.quantityType(forIdentifier: .oxygenSaturation)!
        let oxygenSaturationUnit = HKUnit.percent()
        let oxygenSaturationvalue=Int.random(in: 0...3)+97
        let oxygenSaturationQuantity=HKQuantity(unit: oxygenSaturationUnit, doubleValue: Double(oxygenSaturationvalue))
        let sample1 = HKQuantitySample(type: oxygenSaturation, quantity: oxygenSaturationQuantity, start: Date(), end: Date())
        healthStore.save(sample1){ success, error in
            if success{
                
            }
            else{
                
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="PausePage"{
            let target = segue.destination as! H2_HikePauseViewController
            target.distancevalue=totalDistanceValue
            target.targetDistance = targetDistance
            target.defaultRoute = defaultRoute
            target.heartratevalue=heartrate
            target.starttime=starttime
            target.weight=weight
            target.CaloriesBurn=CaloriesBurn
            target.AvgPace=AvgPace
            target.interval1=interval1
            target.count=count
            target.yValue=yValue
            target.heartratearray=heartratearray
            target.age=age
            target.elevation=elevation
            target.peak = peak
            target.userLocationsCoordinates = self.userLocationsCoordinates
            let sumArray=oxygenSaturationarray.reduce(0, +)
            oxygenSaturation = sumArray / Double(oxygenSaturationarray.count)
            target.oxygenSaturation=oxygenSaturation
        }
    }
    func saveMockDistanceWalking(){
        let distanceWalkingRunning=HKSampleType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let distanceUnit = HKUnit.meter()
        let number =  Double.random(in: 0...0.8)
        let distanceQuantity=HKQuantity(unit: distanceUnit, doubleValue: Double(number))
        let sample1 = HKQuantitySample(type: distanceWalkingRunning, quantity: distanceQuantity, start: Date(), end: Date())
        healthStore.save(sample1){ success, error in
            if success{
                
            }
            else{
                
            }
        }}
    
    func timer(){
        timer1=Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            self.count!+=1
            var timeText = ""
            
            if (self.count!%1800)==0&&(self.count! != 0){
                scheduleNotification(title: "Time to drink some water", body: "Total distance: \(String(format:"%0.2f",self.totalDistance)) m")
            }
            
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
            self.timeLabel.text = timeText
            
        }
    }
    
    func startMockData() {
        timer2=Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.saveMockHeartRate()
            self.saveMockDistanceWalking()
            self.saveMockOxygenSaturation()
        }
    }
    
    func pauseMockData(){
        timer1?.invalidate()
        timer1=nil
        timer2?.invalidate()
        timer2=nil
    }
    func testDistanceQuery() {
        let distanceWalkingRunning = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!
        let minly=DateComponents(day:1)
        let predicate=HKQuery.predicateForSamples(withStart: starttime, end: nil, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: distanceWalkingRunning, quantitySamplePredicate: predicate, options: HKStatisticsOptions.mostRecent, anchorDate: starttime!, intervalComponents: minly)
        
        query.initialResultsHandler={
            query, statisticsCollection, error in
            if let statisticsCollection=statisticsCollection{
                self.updateDistanceUIFromStatistics(statisticsCollection)
            }
        }
        query.statisticsUpdateHandler={query, statistics, statisticsCollection, error in
            if let statisticsCollection=statisticsCollection{
                self.updateDistanceUIFromStatistics(statisticsCollection)
            }
        }
        healthStore.execute(query)
    }

    func updateDistanceUIFromStatistics(_ statisticsCollection:HKStatisticsCollection){

        DispatchQueue.main.async {
            statisticsCollection.enumerateStatistics(from: self.starttime!, to: Date()){
                [weak self](statistics,stop) in
                guard let hikingdistance: Double = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter()) else { return }
                var distanceH=Double(hikingdistance)
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
                formatter.roundingMode = .halfUp
                distanceH=Double(formatter.string(for: hikingdistance)!)!
                self!.distance=distanceH
                self!.totalDistanceValue = distanceH
                let CaloriesB:Double
                CaloriesB=Double(formatter.string(for:self!.CaloriesBurned(distance: distanceH))!)!
                self?.CaloriesBurn=CaloriesB
                let distance_attributedText = NSMutableAttributedString(string: String(format: "%.2f", distanceH), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)])
                if self!.targetDistance == nil {
                    distance_attributedText.append(NSAttributedString(string: " m", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]))
                } else {
                    distance_attributedText.append(NSAttributedString(string: " m / \(self!.targetDistance!) km", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]))
                }
                self?.distanceLabel.attributedText = distance_attributedText
                self?.Calories.text=String("\(CaloriesB) cal")
                
                if self?.firstTime == true{
                    self?.pavilionPoints.append(CLLocation(latitude: 22.503366, longitude: 114.239618))
                    self?.toiletPoints.append(CLLocation(latitude: 22.502427, longitude: 114.237318))
                    self?.pathPoints.append(CLLocation(latitude: 22.2712, longitude: 114.1493))
                    self?.pathPoints.append(CLLocation(latitude: 22.2713, longitude: 114.1484))
                    self?.pathPoints.append(CLLocation(latitude: 22.2710, longitude: 114.1482))
                    self?.pathPoints.append(CLLocation(latitude: 22.2706, longitude: 114.1481))
                    self?.pathPoints.append(CLLocation(latitude: 22.2699, longitude: 114.1475))
                    self?.pathPoints.append(CLLocation(latitude: 22.2694, longitude: 114.1471))
                    self?.pathPoints.append(CLLocation(latitude: 22.2688, longitude: 114.1464))
                    self?.pathPoints.append(CLLocation(latitude: 22.2684, longitude: 114.1456))
                    self?.pathPoints.append(CLLocation(latitude: 22.2683, longitude: 114.1450))
                    self?.pathPoints.append(CLLocation(latitude: 22.2679, longitude: 114.1446))
                    self?.pathPoints.append(CLLocation(latitude: 22.2672, longitude: 114.1441))
                    self?.pathPoints.append(CLLocation(latitude: 22.2668, longitude: 114.1439))
                    self?.pathPoints.append(CLLocation(latitude: 22.2667, longitude: 114.1428))
                    self?.pathPoints.append(CLLocation(latitude: 22.2662, longitude: 114.1422))
                    self?.pathPoints.append(CLLocation(latitude: 22.2664, longitude: 114.1403))
                    self?.pathPoints.append(CLLocation(latitude: 22.2666, longitude: 114.1394))
                    self?.pathPoints.append(CLLocation(latitude: 22.2662, longitude: 114.1382))
                    self?.pathPoints.append(CLLocation(latitude: 22.2657, longitude: 114.1371))
                    self?.pathPoints.append(CLLocation(latitude: 22.2641, longitude: 114.1361))
                    self?.pathPoints.append(CLLocation(latitude: 22.2634, longitude: 114.1356))
                    self?.firstTime = false
                }
                self?.nearSomePoint()
                self?.awayFromPath()
                
                if ((self?.doneloadDate) != nil) {
                    let interval2 = Date()-self!.starttime!
                    let interval=interval2.second!-self!.interval1!
                    let pacValue1=Int(distanceH)*100/interval
                    let pacValue2=Double(formatter.string(for: pacValue1)!) ?? 0
                    self?.AvgPace=pacValue2
                    
                    let pace_attributedText = NSMutableAttributedString(string: String(format: "%.2f", pacValue2*0.036), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)])
                    pace_attributedText.append(NSAttributedString(string: " km/hr", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
                    self?.distanceLabel.attributedText = distance_attributedText
                    self?.averagePaceLabel.attributedText=pace_attributedText
                    
                }else{
                    let interval = Date()-self!.starttime!
                    var pacValue=distanceH*100/Double((Int(interval.second!)))
                    pacValue=Double(formatter.string(for: pacValue)!) ?? 0
                    self?.AvgPace=pacValue
                    
                    let pace_attributedText = NSMutableAttributedString(string: String(format: "%.2f", pacValue*0.036), attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 32)])
                    pace_attributedText.append(NSAttributedString(string: " km/hr", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]))
                    self?.distanceLabel.attributedText = distance_attributedText
                    self?.averagePaceLabel.attributedText = pace_attributedText
                }
         
            }
        }
    }
    
    func nearSomePoint(){
        var n=0
        for pavilion in pavilionPoints{
            distance = currentLocation.distance(from: pavilion)
            if distance! < 100.0{
                scheduleNotification(title: "Pavilion is nearby", body: "You may take a rest there")
                notifiedPavilionPoints.append(pavilion)
                pavilionPoints.remove(at: n)
            }
            n+=1
        }
        
        n=0
        for pavilion in notifiedPavilionPoints{
            distance = currentLocation.distance(from: pavilion)
            if distance! > 300.0{
                pavilionPoints.append(pavilion)
                notifiedPavilionPoints.remove(at: n)
            }
            n+=1
        }
        
        n=0
        for toilet in toiletPoints{
            distance = currentLocation.distance(from: toilet)
            if distance! < 100.0{
                scheduleNotification(title: "Toilet is nearby", body: "You may go to toilet")
                notifiedToiletPoints.append(toilet)
                toiletPoints.remove(at: n)
            }
            n+=1
        }
        
        n=0
        for toilet in notifiedToiletPoints{
            distance = currentLocation.distance(from: toilet)
            if distance! > 300.0{
                toiletPoints.append(toilet)
                notifiedToiletPoints.remove(at: n)
            }
            n+=1
        }
    }
    
    func awayFromPath(){
        var away=true
        for checkPoint in pathPoints{
            distance = currentLocation.distance(from: checkPoint)
            if distance! < 100.0 || distance! > 2000.0{
                away=false
            }
        }
        if away == true{
            scheduleNotification(title: "Warning", body: "You are away from path")
        }
    }
    
    func CaloriesBurned(distance:Double) -> Double{
        return 0.5865*distance/1000*self.weight!
    }
    func testHeartRateQuery() {
        let HeartRate = HKObjectType.quantityType(forIdentifier: .heartRate)!
        let minly=DateComponents(day:1)
        let predicate=HKQuery.predicateForSamples(withStart: starttime, end: nil, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: HeartRate, quantitySamplePredicate: predicate, options: HKStatisticsOptions.mostRecent, anchorDate: starttime!, intervalComponents: minly)
        
        query.initialResultsHandler={
            query, statisticsCollection, error in
            if let statisticsCollection=statisticsCollection{
                self.updateHeartRateUIFromStatistics(statisticsCollection)
            }
        }
        if isPaused{
            query.statisticsUpdateHandler={query, statistics, statisticsCollection, error in
                if let statisticsCollection=statisticsCollection{
                    self.updateHeartRateUIFromStatistics(statisticsCollection)
                }
            }
                healthStore.execute(query)
        }else{
            healthStore.stop(query)
        }
        
    }
    func testOxygenSaturtion(){
        let OxygenSaturtion = HKObjectType.quantityType(forIdentifier:.oxygenSaturation)
        let minly=DateComponents(day:1)
        let predicate=HKQuery.predicateForSamples(withStart: starttime, end: nil, options: .strictStartDate)
        let query = HKStatisticsCollectionQuery(quantityType: OxygenSaturtion!, quantitySamplePredicate: predicate, options: HKStatisticsOptions.mostRecent, anchorDate: starttime!, intervalComponents: minly)
        query.initialResultsHandler={
            query, statisticsCollection, error in
            if let statisticsCollection=statisticsCollection{
                self.updateOxygenSaturtionUIFromStatistics(statisticsCollection)}}
        query.statisticsUpdateHandler={query, statistics, statisticsCollection, error in
            if let statisticsCollection=statisticsCollection{
                self.updateOxygenSaturtionUIFromStatistics(statisticsCollection)
                }
            }
        healthStore.execute(query)
    }
        
    func updateOxygenSaturtionUIFromStatistics(_ statisticsCollection:HKStatisticsCollection){
        statisticsCollection.enumerateStatistics(from: self.starttime!, to: Date()){
            [weak self](statistics,stop) in
            guard let OxygenPerS: Double = statistics.mostRecentQuantity()?.doubleValue(for: HKUnit.percent()) else { return }
            DispatchQueue.main.async {
                self!.OxygenSaturation.text=String(format: "%.2f", OxygenPerS) + " %"
                self!.oxygenSaturationarray.append(OxygenPerS)
            }
        }}
    func updateHeartRateUIFromStatistics(_ statisticsCollection:HKStatisticsCollection){
        statisticsCollection.enumerateStatistics(from: self.starttime!, to: Date()){
            [weak self](statistics,stop) in
            guard let beatsPerMinute: Double = statistics.mostRecentQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute())) else { return }
            let resultCount = Int(beatsPerMinute)
            self?.heartrate = resultCount
            let countb:Double = Double(self!.count!)/60
            self?.yValue.append(ChartDataEntry(x: countb, y: Double(resultCount)))
            self?.heartratearray.append(Double(resultCount))
        DispatchQueue.main.async {
            self?.bpmLabel.text=String("\(resultCount)")
            if resultCount > Int(Double((220-self!.age!))*0.9){
                scheduleNotification(title: "heart Rate", body: "too high")
            }
            }
            
        }
    }
    func ReadingWeight(){
        let WeightType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!
        let query = HKSampleQuery(sampleType: WeightType, predicate: nil, limit: 1, sortDescriptors: nil) { (query, results, error) in
            if let result = results?.first as? HKQuantitySample{
                self.weight = result.quantity.doubleValue(for: HKUnit.pound())
            }else{
                print("OOPS didnt get Weight \nResults => \(String(describing: results)), error => \(String(describing: error))")
            }
        }
        healthStore.execute(query)
    }
    
    func WritingWeight(){
        let Weight = Double.random(in: 60...200)

        if let type = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) {
            let date = Date()
            let quantity = HKQuantity(unit: HKUnit.pound(), doubleValue: Double(Weight))
            let sample = HKQuantitySample(type: type, quantity: quantity, start: date, end: date)
            healthStore.save(sample, withCompletion: { (success, error) in
                print("Saved \(success), error \(String(describing: error))")
            })
        }
    }
    

    /*func testHeartRateAnchoredQuery() {
        guard let heartrate = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            fatalError("*** Unable to get the heartrate ***")
        }
        
        var anchor = HKQueryAnchor.init(fromValue: 0)
        
        if UserDefaults.standard.object(forKey: "Anchor") != nil {
            let data = UserDefaults.standard.object(forKey: "Anchor") as! Data
            anchor = NSKeyedUnarchiver.unarchiveObject(with: data) as! HKQueryAnchor
        }
        
        let query = HKAnchoredObjectQuery(type: heartrate,
                                          predicate: nil,
                                          anchor: anchor,
                                          limit: HKObjectQueryNoLimit) { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in
            guard let samples = samplesOrNil, let _ = deletedObjectsOrNil else {
                                                fatalError("*** An error occurred during the initial query: \(errorOrNil!.localizedDescription) ***")
                                            }
                                            
                                            anchor = newAnchor!
                                            let data : Data = NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any)
                                            UserDefaults.standard.set(data, forKey: "Anchor")
            
                                            for heartrateSample in samples {
                                                DispatchQueue.main.async {
                                                    self.heartRateText.text=String("BPM: \(heartrateSample)").maxLength(length:18)
                                                }}
            
                                            
                                            print("Anchor: \(anchor)")
        }
        
        query.updateHandler = { (query, samplesOrNil, deletedObjectsOrNil, newAnchor, errorOrNil) in

            guard let samples = samplesOrNil, let _ = deletedObjectsOrNil else {
                // Handle the error here.
                fatalError("*** An error occurred during an update: \(errorOrNil!.localizedDescription) ***")
            }

            anchor = newAnchor!
            let data : Data = NSKeyedArchiver.archivedData(withRootObject: newAnchor as Any)
            UserDefaults.standard.set(data, forKey: "Anchor")

            for heartrateSample in samples {
                DispatchQueue.main.async {
                    self.heartRateText.text=String("BPM: \(heartrateSample)").maxLength(length:18)
                }}

        }
        
        healthStore.execute(query)
    }*/
    
    
    
//        @IBAction func distanceTapped(_ sender: UIBarButtonItem) {
//            let locations: [CLLocationCoordinate2D] = [...]
//            var total: Double = 0.0
//            for i in 0..<locations.count - 1 {
//                let start = locations[i]
//                let end = locations[i + 1]
//                let distance = getDistance(from: start, to: end)
//                total += distance
//            }
//            print(total)
//        }
//
//        func getDistance(from: CLLocationCoordinate2D, to: CLLocationCoordinate2D) -> CLLocationDistance {
//            // By Aviel Gross
//            // https://stackoverflow.com/questions/11077425/finding-distance-between-cllocationcoordinate2d-points
//            let from = CLLocation(latitude: from.latitude, longitude: from.longitude)
//            let to = CLLocation(latitude: to.latitude, longitude: to.longitude)
//            return from.distance(from: to)
//        }
    
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0] as CLLocation
        let userCenter = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        currentLocation = userLocation
        
        self.userLocationsCoordinates.append(userCenter)
        print("self.userLocationsCoordinates: ", self.userLocationsCoordinates.count)
        DispatchQueue.main.async {
            let polyline = MKPolyline(coordinates: self.userLocationsCoordinates, count: self.userLocationsCoordinates.count)
            self.mapView.addOverlay(polyline)
        }
            
        userRegion = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(userRegion, animated: false)
        
        elevation = userLocation.altitude
        if elevation > peak {
            peak = elevation
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
    
    
    // MARK: - Navigation

    @IBAction func returned(segue: UIStoryboardSegue) {
        let source_H2 = segue.source as! H2_HikePauseViewController
        timeLabel.text = source_H2.time.text
        distanceLabel.text = source_H2.distance.text
    }

    
    // MARK: - Private Functions
    
    private func showMapRoute() {
        self.mapView.removeOverlays(self.mapView.overlays)
        if self.defaultRoute?.midwayPoints.count == 0 {
            self.fetchNextRoute(from: defaultRoute!.startPoint, to: defaultRoute!.endPoint)
        } else {
            let tempRoute = Route(name: defaultRoute!.name, description: defaultRoute!.description, distance: defaultRoute!.distance, expectedTime: defaultRoute!.expectedTime, peak: defaultRoute!.peak, difficulty: defaultRoute!.difficulty, bookmarked: defaultRoute!.bookmarked, district: defaultRoute!.district, startPoint: defaultRoute!.startPoint, endPoint: defaultRoute!.endPoint, midwayPoints: defaultRoute!.midwayPoints)
            var nextMidwayPoint = tempRoute.midwayPoints.removeFirst()
            self.fetchNextRoute(from: defaultRoute!.startPoint, to: nextMidwayPoint.coordinate)
            while tempRoute.midwayPoints.count > 0 {
                self.fetchNextRoute(from: nextMidwayPoint.coordinate, to: (tempRoute.midwayPoints.first?.coordinate)!)
                nextMidwayPoint = tempRoute.midwayPoints.removeFirst()
            }
            self.fetchNextRoute(from: nextMidwayPoint.coordinate, to: defaultRoute!.endPoint)
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
}

    
extension String {
   func maxLength(length: Int) -> String {
       var str = self
       let nsString = str as NSString
       if nsString.length >= length {
           str = nsString.substring(with:
               NSRange(
                location: 0,
                length: nsString.length > length ? length : nsString.length)
           )
       }
       return  str
   }
}
extension Date {

    static func -(recent: Date, previous: Date) -> (month: Int?, day: Int?, hour: Int?, minute: Int?, second: Int?) {
        let day = Calendar.current.dateComponents([.day], from: previous, to: recent).day
        let month = Calendar.current.dateComponents([.month], from: previous, to: recent).month
        let hour = Calendar.current.dateComponents([.hour], from: previous, to: recent).hour
        let minute = Calendar.current.dateComponents([.minute], from: previous, to: recent).minute
        let second = Calendar.current.dateComponents([.second], from: previous, to: recent).second

        return (month: month, day: day, hour: hour, minute: minute, second: second)
    }

}
