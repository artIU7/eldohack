//
//  MainViewController.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import UIKit

class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = TaskEmployeController()
        let tabOneBarItem = UITabBarItem(title: "Задание", image: UIImage(named: "scan_svg"), selectedImage: UIImage(named: "scan_svg"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = QRScannerAR()
        let tabTwoBarItem2 = UITabBarItem(title: "Scan AR", image: UIImage(named: "nav_svg"), selectedImage: UIImage(named: "nav_svg"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        // Create Tab tree
        let tabTree = StatisticController()
        let tabTreeBarItem3 = UITabBarItem(title: "Статитстика", image: UIImage(named: "stat_svg"), selectedImage: UIImage(named: "stat_svg"))
        
        tabTree.tabBarItem = tabTreeBarItem3
        
        
        self.viewControllers = [tabOne, tabTwo, tabTree]
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let appearance = UITabBarAppearance()
        //appearance.backgroundColor = #colorLiteral(red: 0.3791669923, green: 0.4272061604, blue: 0.434493125, alpha: 0.5) //.red
        
        tabBar.standardAppearance = appearance
        print("Selected \(viewController.title!)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 55
        tabBar.frame.origin.y = view.frame.height - 55
    }
}

