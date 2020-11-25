//
//  F1_SettingViewController.swift
//  Hiking
//
//  Created by Will Lam on 4/11/2020.
//

import UIKit

class F1_SettingViewController: UIViewController {

    var usersDocument: UsersDocument?
    var usersDocumentURL: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loadUsersDocument()
        title = "SETTING"
        navigationController?.title = "Setting"
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - Private Functions
    
    private func loadUsersDocument() {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        usersDocumentURL = dirPaths[0].appendingPathComponent("users.txt")
        usersDocument = UsersDocument(fileURL: usersDocumentURL!)
        
        if fileManager.fileExists(atPath: usersDocumentURL!.path){
            usersDocument!.open(completionHandler: {(success:Bool) in
                if success{
                    print("Load Users Document Success")
                }
            })
        } else {
            usersDocument!.save(to: usersDocumentURL!, for: .forCreating, completionHandler: {(success:Bool) in
                if !success{
                    print("Failed to create Users Document")
                }else{
                    print("Users Document created")
                }
            })
        }
    }
}
