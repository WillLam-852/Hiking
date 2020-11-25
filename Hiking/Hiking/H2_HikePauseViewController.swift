//
//  H2_HikePauseViewController.swift
//  Hiking
//
//  Created by Will Lam on 23/11/2020.
//

import UIKit

class H2_HikePauseViewController: UIViewController {
    @IBOutlet weak var Pace: UILabel!
    @IBOutlet weak var Calories: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var heartrate: UILabel!
    @IBOutlet weak var distance: UILabel!

    var starttime:Date!
    var weight:Double?
    var heartratevalue:Int?
    var distancevalue:Double?
    var CaloriesBurn:Double?
    var AvgPace:Double?
    var doneloadtime:Date?
    var interval1:Int?=0
    var count:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        heartrate.text=String("BPM: \(heartratevalue!) count/min")
        distance.text=String("Distance: \(distancevalue!)m")
        Calories.text=String("Calories: \(CaloriesBurn!) cal")
        Pace.text=String("Pace: \(AvgPace!)")
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

        self.navigationItem.leftBarButtonItem=nil;
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="ReturnMainPage"{
            let target = segue.destination as! H1_HikeOnProgressViewController
            target.doneload=true
            target.starttime=starttime
            target.weight=weight
            target.doneloadDate=doneloadtime
            target.interval1=interval1
            target.count=count
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

