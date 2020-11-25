//
//  H1_HikeOnProgressViewController.swift
//  Hiking
//
//  Created by Will Lam on 23/11/2020.
//

import UIKit
import CoreLocation
import MapKit
import HealthKit
import Charts
import TinyConstraints

class H1_HikeOnProgressViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var averagePaceLabel: UILabel!
    @IBOutlet weak var bpmLabel: UILabel!
    @IBOutlet weak var Calories: UILabel!
    @IBOutlet weak var PauseButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func pressedPauseButton(_ sender: UIButton) {
        pauseMockData()
    }
    
    @IBAction func pressedMusicButton(_ sender: UIButton) {
        pauseMockData()
    }
    
    @IBAction func pressedCameraButton(_ sender: UIButton) {
    }

    
    var doneload = false
    let healthStore = HKHealthStore()
    var timer1: Timer?
    var timer2: Timer?
    var count:Int?=0
    var isPaused = true
    var starttime: Date?
    var weight:Double?=1
    
    var yValue:[ChartDataEntry] = []
    var heartrate:Int?=0
    var distance:Double?=0
    var CaloriesBurn:Double?=0
    var AvgPace:Double?=0
    var doneloadDate:Date?
    var interval1:Int?=0
    var age:Int?=0
    var heartratearray:[Double]=[]

    var locationManager: CLLocationManager = CLLocationManager()
    var userRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide Navigation Bar and Tab Bar
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        mapView.showsUserLocation = true
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
                                       HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!]
            
            let writeDataTypes : Set = [HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.heartRate)!,
                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                                        HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!]
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
        let Heartrate = Int.random(in: 0...90)+100
        let heartRateQuantity=HKQuantity(unit: heartRateUnit, doubleValue: Double(Heartrate))
        let sample1 = HKQuantitySample(type: heartRate, quantity: heartRateQuantity, start: Date(), end: Date())
        healthStore.save(sample1){ success, error in
            if success{
                
            }
            else{
                
            }
        }}
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="PausePage"{
            let target = segue.destination as! H2_HikePauseViewController
            target.distancevalue=distance
            target.heartratevalue=heartrate
            target.starttime=starttime
            target.weight=weight
            target.CaloriesBurn=CaloriesBurn
            target.AvgPace=AvgPace
            target.interval1=interval1
            target.count=count
        }
        if segue.identifier=="StopPage" {
            let target = segue.destination as! H3_HikeFinishViewController
            target.yValue=yValue
            target.distancevalue=distance
            target.CaloriesBurn=CaloriesBurn
            target.AvgPace=AvgPace
            target.count=count
            target.heartratearray=heartratearray
            target.age=age
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
            self.count=self.count!+1
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
            self.timeLabel.text = timeText
            
        }
    }
    
    func startMockData() {
        timer1=Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.saveMockHeartRate()
            self.saveMockDistanceWalking()
        }
    }
    
    func pauseMockData(){
        if isPaused{
            timer1?.invalidate()
            isPaused=false
            }
        else{
            timer1=Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                self.saveMockHeartRate()
                self.isPaused=true
            }
        }
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
        if isPaused{
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
                self?.distance=distanceH
                let CaloriesB:Double
                CaloriesB=Double(formatter.string(for:self!.CaloriesBurned(distance: distanceH))!)!
                self?.CaloriesBurn=CaloriesB
                self?.distanceLabel.text=String("\(distanceH) m")
                self?.Calories.text=String("\(CaloriesB) cal")
                if ((self?.doneloadDate) != nil) {
                    let interval2 = Date()-self!.starttime!
                    let interval=interval2.second!-self!.interval1!
                    let pacValue1=Int(distanceH)*100/interval
                    let pacValue2=Double(formatter.string(for: pacValue1)!) ?? 0
                    self?.AvgPace=pacValue2
                    self?.averagePaceLabel.text=String("\(pacValue2)")
                    
                }else{
                    let interval = Date()-self!.starttime!
                    var pacValue=distanceH*100/Double((Int(interval.second!)))
                    pacValue=Double(formatter.string(for: pacValue)!) ?? 0
                    self?.AvgPace=pacValue
                    self?.averagePaceLabel.text=String("\(pacValue)")
                }
                
                
                
            }}
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
            self?.bpmLabel.text=String("\(resultCount) count/min")
            if resultCount > Int(Double((220-self!.age!))*0.9){
                LocalNotificationManager.setNotification(1, of: .seconds, repeats: false, title: "Heart Rate is too high", body: "Need to take rest", userInfo: ["aps":["Hello": "world"]])
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
        userRegion = MKCoordinateRegion(center: userCenter, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(userRegion, animated: true)
        
        print("Location changed! \(locations.count) location(s) detected")
        for item in locations {
            print("\(item)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error - locationManager: \(error.localizedDescription)")
    }
    
    
    // MARK: - Navigation

    @IBAction func returned(segue: UIStoryboardSegue) {
        let source_H2 = segue.source as! H2_HikePauseViewController
        timeLabel.text = source_H2.time.text
        distanceLabel.text = source_H2.distance.text
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
