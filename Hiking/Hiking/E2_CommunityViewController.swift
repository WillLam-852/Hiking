//
//  E2_CommunityViewController.swift
//  Hiking
//
//  Created by Edwin on 22/11/2020.
//

import UIKit

class E2_CommunityViewController: UIViewController {

    @IBOutlet weak var lb_writer: UILabel!
    @IBOutlet weak var lb_date: UILabel!
    @IBOutlet weak var TF_title: UITextField!
    @IBOutlet weak var TV_content: UITextView!
    @IBOutlet weak var bt_save: UIBarButtonItem!
    
    var post:Post?
    var newPost:Bool=true
    var dFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TF_title.placeholder="Title"
        TV_content.layer.borderColor=UIColor.black.cgColor
        TV_content.layer.borderWidth = 1
        
        // Do any additional setup after loading the view.
        dFormatter.dateFormat="dd-MMM-yyyy"
        if let p=post{
            lb_writer.text=p.writer
            lb_date.text=dFormatter.string(from:p.date)
            TF_title.text=p.title
            TV_content.text=p.content
            newPost=false
            if p.writer != userA.userName{
                bt_save.isEnabled = false
                TV_content.isEditable = false
            }
        }else{
            lb_writer.text=currentUser.userName
            lb_date.text=dFormatter.string(from:Date())
            TV_content.text=""
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier=="PostSaveReturn"{
            dFormatter.dateFormat="dd-MMM-yyyy"
            if TF_title.text == ""{
                TF_title.text = "No Title"
            }
            if TV_content.text == ""{
                TV_content.text = "No Content"
            }
            post=Post(writer: lb_writer.text!, title: TF_title.text!, content: TV_content.text!, date: Date())
        }
    }
}
