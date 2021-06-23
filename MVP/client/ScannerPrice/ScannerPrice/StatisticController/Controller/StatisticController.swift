//
//  StatisticController.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import UIKit

class StatisticController: UIViewController {

    // custom tint tab bar
    var tabBarTag: Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Статистика"
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          
           if tabBarTag == true {
            self.tabBarController?.tabBar.tintColor =  #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)//UIColor.blue
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)//UIColor.cyan
           } else {
               self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
    }
}
