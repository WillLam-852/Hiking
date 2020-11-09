//
//  A2_HomeRouteSelectionViewController.swift
//  Hiking
//
//  Created by Will Lam on 5/11/2020.
//

import UIKit

class A2_HomeRouteSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var routeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        routeTableView.delegate = self
        routeTableView.dataSource = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - UITableViewDelegate
    
    @IBAction func pressedFilterButton(_ sender: UIButton) {
    }
    
    @IBAction func pressedShowMapButton(_ sender: UIButton) {
    }
    
    
    // MARK: - Actions
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = routeTableView.dequeueReusableCell(withIdentifier: "routeCellID", for: indexPath) as! A2_RouteTableViewCell
        
        cell.routeName_label.text = routeList[indexPath.row].name
        cell.routeDistance_label.text = String(routeList[indexPath.row].distance) + " km"
        cell.routeExpectedTime_label.text = String(routeList[indexPath.row].expectedTime) + " hrs"
        cell.routePeak_label.text = "最高點: " + String(routeList[indexPath.row].peak) + " m"
        cell.routeDifficulty_label.text = String(routeList[indexPath.row].difficulty) + " Star(s)"
        
        return cell
    }
}
