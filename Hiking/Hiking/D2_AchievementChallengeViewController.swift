//
//  D2_AchievementChallengeViewController.swift
//  Hiking
//
//  Created by Will Lam on 5/11/2020.
//

import UIKit

class D2_AchievementChallengeViewController: UIViewController {
    
    var count:Int?=0
    @IBOutlet weak var background1: UILabel!
    @IBOutlet weak var background2: UILabel!
    @IBOutlet weak var background3: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var background_1: UITextView!
    @IBOutlet weak var background_2: UITextView!
    @IBOutlet weak var background_3: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for i in currentUser.userHikeRecord{
            let time = i.recordedDate.get(.month)
            print(time)
            label.text=String("time")
            if time==11{
                count!+=1
                if i.routeReference!.difficulty==5{
                    background3.layer.backgroundColor=UIColor.yellow.cgColor
                    background_3.layer.backgroundColor=UIColor.yellow.cgColor
                }
                if i.recordedDistance>10{
                    background1.layer.backgroundColor=UIColor.yellow.cgColor
                    background_1.layer.backgroundColor=UIColor.yellow.cgColor
                    
                }
            }
        }
        if count!>15{
            background2.layer.backgroundColor=UIColor.yellow.cgColor
            background_2.layer.backgroundColor=UIColor.yellow.cgColor
        }
        

        // Do any additional setup after loading the view.
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
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
