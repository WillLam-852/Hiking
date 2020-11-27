//
//  E1_CommunityTableViewController.swift
//  Hiking
//
//  Created by Edwin on 22/11/2020.
//

import UIKit

class E1_CommunityTableViewController: UITableViewController {
    
    var selectedRowNum = -1
    var firstTime = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "COMMUNITY"
        navigationController?.title = "Community"
        let fileManager=FileManager.default
        let dirPaths=fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        postsDocumentURL=dirPaths[0].appendingPathComponent("posts.txt")
        postsDocument=PostDocument(fileURL: postsDocumentURL!)
        
        if fileManager.fileExists(atPath: postsDocumentURL!.path){
            postsDocument!.open(completionHandler: {(success:Bool) in
                if success{
                    self.tableView.reloadData()
                }
            })
        }else{
            postsDocument!.save(to: postsDocumentURL!, for: .forCreating, completionHandler: {(success:Bool) in
                if !success{
                    print("Failed to create file")
                }else{
                    print("File created")
                }
            })
            newPost(writer: "Ben", title: "A hike on Lung Fu Shan", content: "Anyone wants to go hiking with me this Saturday ?", date: "9-Nov-2020")
            newPost(writer: "Lee", title: "Have a new achievement", content: Achievement4.content, date: "11-Nov-2020")
            
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        tableView.reloadData()
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

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let pd=postsDocument{
            return pd.posts.count
        }
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommunityCellID", for: indexPath) as!E1_CommunityTableViewCell

        // Configure the cell...
        if let pd=postsDocument{
            let dFormatter = DateFormatter()
            dFormatter.dateFormat="dd-MMM-yyyy"
            let post=pd.posts[indexPath.row]
            cell.lb_writer.text=post.writer
            cell.lb_title.text=post.title
            cell.lb_title.font = UIFont.boldSystemFont(ofSize: 22.0)
            cell.lb_content.text=post.content
            cell.lb_date.text=dFormatter.string(from:post.date)
        }
        return cell
    }
    
    @IBAction func returned(segue:UIStoryboardSegue){
        let source=segue.source as! E2_CommunityViewController
        if let pd=postsDocument{
            if source.newPost{
                pd.posts.append(source.post!)
                print("Post added")
            }else{
                pd.posts[selectedRowNum]=source.post!
            }
            pd.save(to: postsDocumentURL!, for: .forOverwriting, completionHandler: {(success:Bool) in
                if !success{
                    print("Failed to update file")
                }else{
                    print("File updated")
                }
            })
        }
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowPost" {
            let target = segue.destination as! E2_CommunityViewController
            if let selectedRow = tableView.indexPathForSelectedRow {
                if let pd=postsDocument{
                    target.post = pd.posts[selectedRow.row]
                    selectedRowNum=selectedRow.row
                }
            }
        }
    }
    

}
