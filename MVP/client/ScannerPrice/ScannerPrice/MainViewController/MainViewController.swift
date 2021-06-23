//
//  MainViewController.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import UIKit
var productCall = ProductAPI()
class MainViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Assign self for delegate for that ViewController can respond to UITabBarControllerDelegate methods
        self.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create Tab one
        let tabOne = PreviewScanController()
        let tabOneBarItem = UITabBarItem(title: "Сканирование", image: UIImage(named: "scan_svg"), selectedImage: UIImage(named: "scan_svg"))
        
        tabOne.tabBarItem = tabOneBarItem
        
        
        // Create Tab two
        let tabTwo = QRScannerAR()
        let tabTwoBarItem2 = UITabBarItem(title: "AR Помощник", image: UIImage(named: "nav_svg"), selectedImage: UIImage(named: "nav_svg"))
        
        tabTwo.tabBarItem = tabTwoBarItem2
        
        // Create Tab tree
        let tabTree = TaskEmployeController()
        let tabTreeBarItem3 = UITabBarItem(title: "Статитстика", image: UIImage(named: "stat_svg"), selectedImage: UIImage(named: "stat_svg"))
        
        tabTree.tabBarItem = tabTreeBarItem3
        
        
        self.viewControllers = [tabOne, tabTwo, tabTree]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                fetch_eldo_api()
            }
    }
    
    // UITabBarControllerDelegate method
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0) //.red
        
        tabBar.standardAppearance = appearance
        print("Selected \(viewController.title!)")
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tabBar.frame.size.height = 55
        tabBar.frame.origin.y = view.frame.height - 55
    }
}

