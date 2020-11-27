//
//  D1_AchievementMedalViewController.swift
//  Hiking
//
//  Created by Will Lam on 4/11/2020.
//

import UIKit

class D1_AchievementMedalViewController: UIViewController {

    @IBOutlet weak var distanceDateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var TimeDateLabel: UILabel!
    @IBOutlet weak var TimeLabel: UILabel!

    @IBOutlet weak var Date1: UILabel!
    @IBOutlet weak var content1: UITextView!
    @IBOutlet weak var Date2: UILabel!
    @IBOutlet weak var content2: UITextView!
    @IBOutlet weak var Date3: UILabel!
    @IBOutlet weak var content3: UITextView!
    var distance:Double?=0
    var time:Double?=0
    var timeDate:Date?
    var hikingrecord:Int?
    var distanceDate:Date?
    var currentUser: User?
    var totaldistance:Double?=0
    var totaltime:Double?=0



    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = User(name: "April", gender: false, birthday: nil, phoneNumber: "11111111", email: "april@gmail.com", profilePicture: nil, hikeRecord:dafaultHikeRecords, friends: nil)
        for i in currentUser!.userHikeRecord{
            if distance==0{
                distance=i.recordedDistance
                distanceDate=i.recordedDate
            }
            else if distance!<i.recordedDistance{
                distance=i.recordedDistance
                distanceDate=i.recordedDate
            }
            else{}
            totaldistance!+=i.recordedDistance
        }
        for x in currentUser!.userHikeRecord{
            if time==0{
                time=x.recordedTime
                timeDate=x.recordedDate
            }
            else if distance!<x.recordedDistance{
                time=x.recordedTime
                timeDate=x.recordedDate
            }
            else{}
            totaltime!+=x.recordedTime
        }
        let dF = DateFormatter()
        dF.dateFormat = "d MMM yyyy"
        distanceDateLabel.text = dF.string(from: distanceDate!)
        distanceLabel.text=String(format: "%.2f", distance!)+" km"
        hikingrecord=userA.userHikeRecord.count
        TimeDateLabel.text=dF.string(from: timeDate!)
        TimeLabel.text=String(format: "%.2f", time!)+" h"
        CheckAchievement()
        updateAchievementUI()
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    func updateAchievementUI(){
        let index=UserAchievement.count
        let dF = DateFormatter()
        dF.dateFormat = "d MMM"
        content1.text=UserAchievement[index-3].content
        Date1.text=dF.string(from: UserAchievement[index-3].date!)
        content2.text=UserAchievement[index-2].content
        Date2.text=dF.string(from: UserAchievement[index-2].date!)
        content3.text=UserAchievement[index-1].content
        Date3.text=dF.string(from: UserAchievement[index-1].date!)
        
    }
    func newPost(writer w: String, title t: String, content c: String, date d: String){
        let dFormatter = DateFormatter()
        dFormatter.dateFormat="dd-MMM-yyyy"
        if let pd = postsDocument{
            pd.posts.append(Post(writer: w, title: t, content: c, date:dFormatter.date(from: d)!))
            postsDocument=pd
            pd.save(to: postsDocumentURL!, for: .forOverwriting, completionHandler: {(success:Bool) in
                if !success{
                    print("Failed to update file")
                }else{
                    print("File updated")
                }
            })
        }
    }
    
    func CheckAchievement(){
        let df=DateFormatter()
        df.dateFormat="dd-MMM-yyyy"
        for i in UserAchievement{
            var count=0
            for y in defaultAchievement{
                if (i.id==y.id){
                    defaultAchievement.remove(at: count)
                }
                count += 1
            }}
        for x in defaultAchievement{
            if x.id==0{
                for y in currentUser!.userHikeRecord{
                    if y.routeReference!.name=="衛奕信徑第九段"{
                        UserAchievement.append(x)
                        scheduleNotification(title: "Achievement Unlock", body: Achievement1.content)
                        newPost(writer: currentUser!.userName, title: "Have a new achievement", content: Achievement1.content, date: df.string(from: Date()))
                    }
                }
            }
            else if x.id==1{
                if totaldistance!>10{
                    print(UserAchievement)
                    UserAchievement.append(x)
                    scheduleNotification(title: "Achievement Unlock", body: Achievement2.content)
                    newPost(writer: currentUser!.userName, title: "Have a new achievement", content: Achievement2.content, date: df.string(from: Date()))
                    
                }
            }
            else if x.id==2{
                if hikingrecord!>5{
                    UserAchievement.append(x)
                    scheduleNotification(title: "Achievement Unlock", body: Achievement3.content)
                    newPost(writer: currentUser!.userName, title: "Have a new achievement", content: Achievement3.content, date: df.string(from: Date()))
                }
            }
            else if x.id==3{
                if totaldistance!>50{
                    UserAchievement.append(x)
                    scheduleNotification(title: "Achievement Unlock", body: Achievement4.content)
                    newPost(writer: currentUser!.userName, title: "Have a new achievement", content: Achievement4.content, date: df.string(from: Date()))
                }
            }
            else if x.id==4{
                if hikingrecord!>15{
                    UserAchievement.append(x)
                    scheduleNotification(title: "Achievement Unlock", body: Achievement5.content)
                    newPost(writer: currentUser!.userName, title: "Have a new achievement", content: Achievement5.content, date: df.string(from: Date()))
                }
            }
            else{
                if time!>5{
                    UserAchievement.append(x)
                    scheduleNotification(title: "Achievement Unlock", body: Achievement6.content)
                    newPost(writer: currentUser!.userName, title: "Have a new achievement", content: Achievement6.content, date: df.string(from: Date()))
                }
            }
        }
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


extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
