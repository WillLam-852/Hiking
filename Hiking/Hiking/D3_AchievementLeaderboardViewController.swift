//
//  D3_AchievementLeaderboardViewController.swift
//  Hiking
//
//  Created by Will Lam on 5/11/2020.
//

import UIKit

class D3_AchievementLeaderboardViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var AchievementTableView: UITableView!
    var frdCount:Int?=0
    var distance:Double? = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        AchievementTableView.delegate = self
        AchievementTableView.dataSource = self
        if currentUser.userFriends==nil{
            frdCount=1
        }
        else{
            //frdCount=currentUser.userFriends.coount
        }
        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AchievementTableViewCell", for: indexPath) as! D3_AchievementTableViewCell
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        cell.Name?.text = String(currentUser.userName)
        for i in currentUser.userHikeRecord{
            distance!+=i.recordedDistance
        }
        cell.totaldistance?.text=String(format: "%0.2f",distance!)+" km"
        return cell
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
