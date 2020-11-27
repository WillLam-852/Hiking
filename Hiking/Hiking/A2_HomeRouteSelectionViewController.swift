//
//  A2_HomeRouteSelectionViewController.swift
//  Hiking
//
//  Created by Will Lam on 5/11/2020.
//

import UIKit
import MapKit

class A2_HomeRouteSelectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var showMapButton: UIButton!
    @IBOutlet weak var routeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HIKE"
        navigationController?.title = "Hike"
        
        self.routeTableView.reloadData()
        routeTableView.delegate = self
        routeTableView.dataSource = self
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRoute" {
            let target = segue.destination as! A2_2_HomeRouteDetailViewController
            if let selectedRow = routeTableView.indexPathForSelectedRow {
                target.currentRoute = routeList[selectedRow.row]
            }
        }
    }
    
    
    // MARK: - UITableViewDelegate
    
    @IBAction func pressedFilterButton(_ sender: UIButton) {
        self.routeTableView.reloadData()
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

        cell.routeImageView.contentMode = .scaleAspectFill
        switch indexPath.row {
        case 0:
            cell.routeImageView.image = UIImage(named: "RouteA")
        case 1:
            cell.routeImageView.image = UIImage(named: "RouteB")
        case 2:
            cell.routeImageView.image = UIImage(named: "RouteC")
        case 3:
            cell.routeImageView.image = UIImage(named: "RouteD")
        case 4:
            cell.routeImageView.image = UIImage(named: "RouteE")
        case 5:
            cell.routeImageView.image = UIImage(named: "RouteF")
        case 6:
            cell.routeImageView.image = UIImage(named: "RouteG")
        case 7:
            cell.routeImageView.image = UIImage(named: "RouteH")
        case 8:
            cell.routeImageView.image = UIImage(named: "RouteI")
        case 9:
            cell.routeImageView.image = UIImage(named: "RouteJ")
        default:
            cell.routeImageView.image = UIImage(systemName: "map")
        }
        cell.routeName_label.text = routeList[indexPath.row].name
        cell.routeDistance_label.text = String(routeList[indexPath.row].distance) + " km"
        cell.routeExpectedTime_label.text = String(routeList[indexPath.row].expectedTime) + " hours"
        cell.routePeak_label.text = "最高點: " + String(routeList[indexPath.row].peak) + " m"
        cell.routeDifficulty_label.text = String(routeList[indexPath.row].difficulty) + " star(s)"
        cell.bookmarkedLabel.text = String(routeList[indexPath.row].bookmarked)
            
        return cell
    }
    
}
