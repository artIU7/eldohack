//
//  QRARScanner.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import Foundation
import UIKit
import ARKit
import SnapKit


class QRScannerAR: UIViewController,ARSCNViewDelegate, ARSessionDelegate {
    var sceneView = ARSCNView()
    var discoveredQRCodes = [String]()
    // custom tint tab bar
    var tabBarTag: Bool = true
    let updateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! +
        ".serialSceneKitQueue")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "AR Помощник"
        sceneView.delegate = self
        //sceneView.showsStatistics = true
        //sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
        sceneView.scene = SCNScene()
        //sceneView.showsStatistics = true
        self.view.addSubview(sceneView)
        self.view.addSubview(sceneView)
        sceneView.snp.makeConstraints { (marker) in
            marker.top.bottom.equalToSuperview().inset(0)
            marker.left.right.equalToSuperview().inset(0)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
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
            let configuration = ARWorldTrackingConfiguration()
        
            sceneView.session.run(configuration)
            sceneView.session.delegate = self
            if tabBarTag == true {
            self.tabBarController?.tabBar.tintColor =  #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)///UIColor.blue
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //UIColor.cyan
           } else {
               self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
    }
}
extension QRScannerAR {
 
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        updateQueue.async { [self] in
        let image = CIImage(cvPixelBuffer: frame.capturedImage)
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: nil)
        let features = detector!.features(in: image)
        
        for feature in features as! [CIQRCodeFeature] {
            if !discoveredQRCodes.contains(feature.messageString!) {
                discoveredQRCodes.append(feature.messageString!)
                let position = SCNVector3(frame.camera.transform.columns.3.x,
                                          frame.camera.transform.columns.3.y - 0.1,
                                          frame.camera.transform.columns.3.z)
                print(position)
                let node = SCNNode()
                sceneView.scene.rootNode.addChildNode(node)
                node.position = position
                //add3DText(text: "Honor Magic", toPosition: position)
                let geometry = SCNSphere(radius: 0.01)
                let color = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                geometry.materials.first?.diffuse.contents = color
                let sphereNode = SCNNode(geometry: geometry)
                sphereNode.position = position
                node.addChildNode(sphereNode)
                sceneView.scene.rootNode.addChildNode(sphereNode)
                
                    }
                }
             }
    }
    func add3DText(text: String, toPosition position: SCNVector3) {
//        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let cube = SCNText(string: "A", extrusionDepth: 0.0)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        cube.materials = [material]
        let node = SCNNode(geometry: cube)
//        node.position = SCNVector3(x: -0.2, y: 0.1, z: -0.5)
        node.position = position
        print(position)
        self.sceneView.scene.rootNode.addChildNode(node)
        print("HELLO")
    }
}
