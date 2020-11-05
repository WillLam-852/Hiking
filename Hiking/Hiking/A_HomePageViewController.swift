//
//  A_HomePageViewController.swift
//  Hiking
//
//  Created by Will Lam on 5/11/2020.
//

import UIKit

class A_HomePageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    
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

        // Do any additional setup after loading the view.
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
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil } // Get the current page index
        let nextIndex = viewControllerIndex + 1 // Get the next page index
        guard nextIndex < pages.count else { return pages.first } // If the current page index is the last one, go to the first page index
        guard pages.count > nextIndex else { return nil } // If the next page index is larger than the total number of pages, there is an error
        return pages[nextIndex]
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
