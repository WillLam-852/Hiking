//
//  A_HomePageViewController.swift
//  Hiking
//
//  Created by Will Lam on 5/11/2020.
//

import UIKit

class A_HomePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var routesDocument: RoutesDocument?
    var routesDocumentURL: URL?
    var hikeRecordsDocument: HikeRecordsDocument?
    var hikeRecordsDocumentURL: URL?
    
    // Identify the Pages for Swiping Action
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "A1"),
            self.getViewController(withIdentifier: "A2"),
            self.getViewController(withIdentifier: "A3")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
        {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "HIKE"
        navigationController?.title = "Hike"
        self.loadRoutesDoucment()
        self.loadHikeRecordsDocument()
        self.delegate = self
        self.dataSource = self
        
        if let firstVC = pages.first {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    
    // MARK: Page View Controller Data Source Functions
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil } // Get the current page index
        let previousIndex = viewControllerIndex - 1 // Get the previous page index
        guard previousIndex >= 0 else { return pages.last } // If the current page index is the first one, go to the last page index
        guard pages.count > previousIndex else { return nil } // If the previous page index is larger than the total number of pages, there is an error
        self.saveRoutesDocument()
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil } // Get the current page index
        let nextIndex = viewControllerIndex + 1 // Get the next page index
        guard nextIndex < pages.count else { return pages.first } // If the current page index is the last one, go to the first page index
        guard pages.count > nextIndex else { return nil } // If the next page index is larger than the total number of pages, there is an error
        self.saveRoutesDocument()
        return pages[nextIndex]
    }
    
    
    // MARK: - Private Functions
    
    private func loadRoutesDoucment() {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        routesDocumentURL = dirPaths[0].appendingPathComponent("routes.txt")
        routesDocument = RoutesDocument(fileURL: routesDocumentURL!)
        
        if fileManager.fileExists(atPath: routesDocumentURL!.path){
            routesDocument!.open(completionHandler: {(success:Bool) in
                if success{
                    print("Load Routes Document Success")
                    if let rD = self.routesDocument {
                        routeList = rD.routes
                    }
                } else {
                    print("Load Default Route List")
                    routeList = defaultRouteList
                }
            })
        } else {
            routesDocument!.save(to: routesDocumentURL!, for: .forCreating, completionHandler: {(success:Bool) in
                if !success{
                    print("Failed to create Routes Document")
                }else{
                    print("Routes Document created")
                }
            })
        }
    }

    
    private func saveRoutesDocument() {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let routesDocumentURL = dirPaths[0].appendingPathComponent("routes.txt")
        let routesDocument = RoutesDocument(fileURL: routesDocumentURL)
        routesDocument.routes = routeList
        routesDocument.save(to: routesDocumentURL, for: .forOverwriting, completionHandler: {(success:Bool) in
            if !success{
                print("Failed to update Route Document")
            }else{
                print("Route Document updated")
            }
        })
    }
    
    
    private func loadHikeRecordsDocument() {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        hikeRecordsDocumentURL = dirPaths[0].appendingPathComponent("hikeRecords.txt")
        hikeRecordsDocument = HikeRecordsDocument(fileURL: hikeRecordsDocumentURL!)
        
        if fileManager.fileExists(atPath: hikeRecordsDocumentURL!.path){
            hikeRecordsDocument!.open(completionHandler: {(success:Bool) in
                if success {
                    print("Load Hike Records Document Success")
                    if let hRD = self.hikeRecordsDocument {
                        currentUser.userHikeRecord = hRD.hikeRecords
                    }
                } else {
                    print("Load Default Hike Record List")
                    currentUser.userHikeRecord = dafaultHikeRecords
                }
            })
        } else {
            hikeRecordsDocument!.save(to: hikeRecordsDocumentURL!, for: .forCreating, completionHandler: {(success:Bool) in
                if !success{
                    print("Failed to create Hike Records Document")
                }else{
                    print("Hike Records Document created")
                }
            })
        }
    }

}
