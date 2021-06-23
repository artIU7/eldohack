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
import WebKit


class QRScannerAR: UIViewController,ARSCNViewDelegate, ARSessionDelegate {
    var sceneView = ARSCNView()
    var discoveredQRCodes = [String]()
    var findQRCodes = [String : SCNVector3]()
    let layerButton = UIButton(type: .system)
    let findButton = UIButton(type: .system)
    var isFindObject = false
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
        configLayout()
        // Do any additional setup after loading the view.
        startAR()
        initTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    func configLayout() {
        let colorButton = #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)
        // layer
        //layerButton.setImage(UIImage(named: "layer_nf_x"), for: .normal)
        layerButton.setTitle("закрыть", for: .normal)
        layerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        layerButton.tintColor = .white
        layerButton.backgroundColor = colorButton
        layerButton.layer.cornerRadius = 10
        
        view.addSubview(layerButton)
        layerButton.addTarget(self, action: #selector(self.layerAction(_:)), for: .touchUpInside)
        layerButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(80)
            marker.top.equalToSuperview().inset(40)
            marker.rightMargin.equalToSuperview().inset(5)
        }
        
        let findColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        // layer
        //layerButton.setImage(UIImage(named: "layer_nf_x"), for: .normal)
        findButton.setTitle("поиск товара", for: .normal)
        findButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        findButton.tintColor = .white
        findButton.backgroundColor = findColor
        findButton.layer.cornerRadius = 10
        
        view.addSubview(findButton)
        findButton.addTarget(self, action: #selector(self.findAction(_:)), for: .touchUpInside)
        findButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(80)
            marker.top.equalToSuperview().inset(40)
            marker.leftMargin.equalToSuperview().inset(5)
        }
    }
        @objc func layerAction(_ sender:UIButton) {
            dismiss(animated: true)
            //runSession()
            //let layerController = LayerViewController()
            //layerController.modalPresentationStyle = .formSheet
                //layerController.modalTransitionStyle = .crossDissolve
            //show(layerController, sender: self)
            //present(layerController, animated: true, completion: nil)
        }
    @objc func findAction(_ sender:UIButton) {
        isFindObject = true
        //runSession()
        //let layerController = LayerViewController()
        //layerController.modalPresentationStyle = .formSheet
            //layerController.modalTransitionStyle = .crossDissolve
        //show(layerController, sender: self)
        //present(layerController, animated: true, completion: nil)
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
            //let configuration = ARWorldTrackingConfiguration()
            //configuration.worldAlignment = .camera

            //sceneView.session.delegate = self
            //sceneView.session.run(configuration)
       //
        //
            if tabBarTag == true {
            self.tabBarController?.tabBar.tintColor =  #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)///UIColor.blue
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //UIColor.cyan
           } else {
               self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
    }
    func startAR() {
        let configuration = ARWorldTrackingConfiguration()

        //configuration.planeDetection = .horizontal

        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.session.delegate = self
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    func initTap() {
         let tapRec = UITapGestureRecognizer(target: self,
                                             action: #selector(QRScannerAR.handleTap(rec:)))
         tapRec.numberOfTouchesRequired = 1
         self.sceneView.addGestureRecognizer(tapRec)
    }
     @objc func handleTap(rec: UITapGestureRecognizer){
        if rec.state == .ended {
            let location: CGPoint = rec.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if let tappednode = hits.first?.node {
                print("tappennode : \(String(describing: tappednode.name))")
                //box(cvb: tappednode.worldPosition)
                if tappednode.name != nil {
                    //let webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
                    //let request = URLRequest(url: URL(string: "https://www.apple.com")!)
                    //webView.load(request)
                    let plane = SCNPlane(width: 0.2,
                                         height: 0.3)
                    //plane.firstMaterial?.diffuse.contents = webView

                    let planeNode = SCNNode(geometry: plane)
                    planeNode.opacity = 0.25
                    planeNode.eulerAngles.x = -.pi
                    self.sceneView.scene.rootNode.addChildNode(planeNode)
                }
            }
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
                print(feature.messageString!)
                print(position)
                findQRCodes[feature.messageString!] = position
                //let node = SCNNode()
                //sceneView.scene.rootNode.addChildNode(node)
                //node.position = position
                if isFindObject != true {
                let geometry = SCNSphere(radius: 0.015)
                let color = #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)
                geometry.materials.first?.diffuse.contents = color
                let sphereNode = SCNNode(geometry: geometry)
                sphereNode.position = position
                sphereNode.nodeAnimation(sphereNode)
                sphereNode.name =  feature.messageString!
                //node.addChildNode(sphereNode)
                sceneView.scene.rootNode.addChildNode(sphereNode)
                } else {
                    if feature.messageString! == "DL-5018777" {
                        addTarget(position: findQRCodes["www.eldorado.ru/cat/detail/71549603/?utm_a=A662"]!)
                    }
             
                }
                // DL-5018777
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
    }
    func addTarget(position : SCNVector3) {
        let tagetFindScene = SCNScene(named: "scn.scnassets/down.scn")! //
        let targetNode = tagetFindScene.rootNode.childNode(withName: "arrow",
                                                                 recursively: false)!
        //let yFreeConstraint = SCNBillboardConstraint()
        //yFreeConstraint.freeAxes = [.Y] // optionally
        //targetNode.constraints = [yFreeConstraint] //
        //targetNode.nodeAnimation(targetNode)
        targetNode.position = position//SCNVector3(0, 0, -0.5)
        targetNode.scale = SCNVector3(0.007, 0.007, 0.007)
        //addChildNode(parentNode)
        sceneView.scene.rootNode.addChildNode(targetNode) //
    }
}
// методы session
extension QRScannerAR {
    
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch camera.trackingState {
        case .normal:
            print("ready")
        case .notAvailable:
            print("wait")
        case .limited(let reason):
            print("limited tracking state: \(reason)")
        }
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
      
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode,
                  for anchor: ARAnchor) {
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
    }
  
}
extension SCNNode {
   public func nodeAnimation(_ nodeAnimation : SCNNode) {
        let animationGroup = CAAnimationGroup.init()
        animationGroup.duration = 1.0
        animationGroup.repeatCount = .infinity
    
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = NSNumber(value: 1.0)
        opacityAnimation.toValue = NSNumber(value: 0.5)
    
        let spin = CABasicAnimation.init(keyPath: "rotation")
        spin.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 25, z: 0, w: 0))
        spin.toValue = NSValue(scnVector4: SCNVector4(x:0, y: 25, z: 0, w: Float(CGFloat(2 * M_PI))))
        spin.duration = 3
        spin.repeatCount = .infinity
        animationGroup.animations = [opacityAnimation,spin]
        nodeAnimation.addAnimation(animationGroup, forKey: "animations")
    }
}
