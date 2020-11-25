//
//  H3_HikeFinishViewController.swift
//  Hiking
//
//  Created by Will Lam on 23/11/2020.
//

import UIKit
import Charts
import TinyConstraints

class H3_HikeFinishViewController: UIViewController, ChartViewDelegate{
    @IBOutlet weak var Pace: UILabel!
    @IBOutlet weak var Calories: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var distance: UILabel!
    
    @IBOutlet weak var Physical: UITextView!
    var heartratearray:[Double]=[]
    var yValue:[ChartDataEntry] = []
    var distancevalue:Double?
    var CaloriesBurn:Double?
    var AvgPace:Double?
    var count:Int?
    var age:Int?=0
    
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
        view.addSubview(lineChartView)
        lineChartView.centerInSuperview()
        lineChartView.width(to: view)
        lineChartView.heightToWidth(of: view)
        
        setData()
        distance.text=String("Distance: \(distancevalue!)m")
        Calories.text=String("Calories: \(CaloriesBurn!) cal")
        Pace.text=String("Pace: \(AvgPace!)")
        self.time.text=String("Time: \(Int(self.count!/3600)):\(Int(self.count!/60)):\(Int(self.count!%60))")
        let sumArray=heartratearray.reduce(0, +)
        let x = sumArray / Double(heartratearray.count)
        if x>(220-Double(self.age!))*0.9{
            Physical.text="Estimated physical fitness: weak => need to take more exercise"
        }
        else if x>(220-Double(self.age!))*0.8{
            Physical.text="Estimated physical fitness: sightly weak => need to take more exercise"
        }
        else if x>(220-Double(self.age!))*0.7{
            Physical.text="Estimated physical fitness: healthy => still need to take more exercise"
        }
        else if x>(220-Double(self.age!))*0.6{
            Physical.text="Estimated physical fitness: good => still need to take more exercise"
        }
        else {
            Physical.text="Estimated physical fitness: excellent => might need to take more exercise"
        }
        
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

    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */



