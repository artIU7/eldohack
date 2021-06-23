//
//  LoginController.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import UIKit
import SnapKit

class PreviewScanController: UIViewController {
    var tabBarTag: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Сканирование"
        configLayout()
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

func configLayout() {
    view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    // заголовок экрана приветсвия
    let titleScreen = UILabel()
    //titleScreen.font = UIFont.systemFont(ofSize: 25)
    titleScreen.font = UIFont.boldSystemFont(ofSize: 25)
    titleScreen.numberOfLines = 0
    titleScreen.text = "Сканер"
    //
    view.addSubview(titleScreen)
    titleScreen.snp.makeConstraints { (marker) in
        marker.left.right.equalToSuperview().inset(20)
        marker.top.equalToSuperview().inset(80)
    }
    let imageView = UIImageView()
    var fonImage = UIImage()
    fonImage = UIImage(named: "scan_scan")!
    
    
    
    imageView.image = fonImage
    view.addSubview(imageView)
    imageView.snp.makeConstraints { (marker) in
        marker.left.right.equalToSuperview().inset(120)
        marker.top.equalTo(titleScreen).inset(190)
        //marker.bottom.equalTo(startTour).inset(100)
        marker.height.equalTo(20)
        marker.width.equalTo(20)
        marker.centerX.centerY.equalToSuperview()
    }
    // button continie
    let startTour = UIButton(type: .system)
    startTour.backgroundColor = #colorLiteral(red: 0.2192575336, green: 0.7275105119, blue: 0.3305970132, alpha: 1)
    startTour.setTitle("Сканировать", for: .normal)
    startTour.setTitleColor(.white, for: .normal)
    startTour.layer.cornerRadius = 10
    startTour.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    view.addSubview(startTour)
    startTour.snp.makeConstraints { (marker) in
        marker.bottom.equalToSuperview().inset(80)
        marker.centerX.equalToSuperview()
        marker.width.equalTo(350)
        marker.height.equalTo(50)
    }
    startTour.addTarget(self, action: #selector(viewTours), for: .touchUpInside)
   /* // page controll
    let pageControl = UIPageControl()
        pageControl.frame = CGRect(x: 100, y: 100, width: 300, height: 300)
        pageControl.numberOfPages = 2;
        pageControl.currentPage = 0;
        view.addSubview(pageControl)
    pageControl.snp.makeConstraints { (marker) in
        marker.bottom.equalTo(startTour).inset(40)
        marker.left.right.equalToSuperview().inset(30)
    }*/
}
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
          
           if tabBarTag == true {
            self.tabBarController?.tabBar.tintColor =  #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)//UIColor.blue
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)//UIColor.cyan
           } else {
               self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)//UIColor.cyan
           }
    }
}
//
extension PreviewScanController {
@objc func viewTours() {
    let viewTours = TextDetectController()//ScannerController()
    //startTest.modalTransitionStyle = .flipHorizontal
    viewTours.modalPresentationStyle = .fullScreen
    viewTours.modalTransitionStyle = .crossDissolve
    show(viewTours, sender: self)
    //present(startTest, animated: true, completion: nil)
    print("Launch second controller")
}
}
