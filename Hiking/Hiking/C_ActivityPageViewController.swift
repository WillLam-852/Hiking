//
//  C_ActivityPageViewController.swift
//  Hiking
//
//  Created by Will Lam on 5/11/2020.
//

import UIKit

class C_ActivityPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
    // Identify the Pages for Swiping Action
    fileprivate lazy var pages: [UIViewController] = {
        return [
            self.getViewController(withIdentifier: "C1"),
            self.getViewController(withIdentifier: "C2")
        ]
    }()
    
    fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
        {
            return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "ACTIVITY"
        navigationController?.title = "Activity"
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
        self.saveHikeRecordsDocument()
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil } // Get the current page index
        let nextIndex = viewControllerIndex + 1 // Get the next page index
        guard nextIndex < pages.count else { return pages.first } // If the current page index is the last one, go to the first page index
        guard pages.count > nextIndex else { return nil } // If the next page index is larger than the total number of pages, there is an error
        self.saveHikeRecordsDocument()
        return pages[nextIndex]
        
    }
    
    
    // MARK: - Private Functions

    private func saveHikeRecordsDocument() {
        let fileManager = FileManager.default
        let dirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let hikeRecordsDocumentURL = dirPaths[0].appendingPathComponent("hikeRecords.txt")
        let hikeRecordsDocument = HikeRecordsDocument(fileURL: hikeRecordsDocumentURL)
        hikeRecordsDocument.hikeRecords = currentUser.userHikeRecord
        hikeRecordsDocument.save(to: hikeRecordsDocumentURL, for: .forOverwriting, completionHandler: {(success:Bool) in
            if !success{
                print("Failed to update Hike Records Document")
            }else{
                print("Hike Records Document updated")
            }
        })
    }

}
