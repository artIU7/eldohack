//
//  ScannerController.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 22.06.2021.
//

import UIKit
import AVFoundation
import SnapKit
import ARKit

var searchingCode : String = ""
class ScannerController: UIViewController {
    // custom tint tab bar
    var tabBarTag: Bool = true
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    let layerButton = UIButton(type: .system)
    let detailCode = UIView()
    let findCode = UILabel()
    var imageDetail = UIImage()
    var priceCode = UILabel()
    var sceneView = ARSCNView()
    let addPointButton = UIButton(type: .system)
    private let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Сканирование"
        // Do any additional setup after loading the view.
        sceneView.delegate = self
        sceneView.debugOptions = [SCNDebugOptions.showFeaturePoints]
        sceneView.backgroundColor = UIColor.clear
        sceneView.scene = SCNScene()
        //sceneView.showsStatistics = true
        self.view.addSubview(sceneView)
        sceneView.snp.makeConstraints { (marker) in
            marker.top.bottom.equalToSuperview().inset(0)
            marker.left.right.equalToSuperview().inset(0)
        }
        //runSession()
      
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [self] in
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                self.failed()
                return
            }
            let avVideoInput: AVCaptureDeviceInput
            
            do {
                avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                self.failed()
                return
            }
            
            if (self.avCaptureSession.canAddInput(avVideoInput)) {
                self.avCaptureSession.addInput(avVideoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                self.avCaptureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr, .ean8, .ean13, .pdf417, .upce, .code128, .code39, .code39Mod43, .code93, .interleaved2of5, .itf14, .upce]
            } else {
                self.failed()
                return
            }
         
            self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.avPreviewLayer.frame = self.view.layer.bounds
            self.avPreviewLayer.videoGravity = .resizeAspectFill
            
            let layer = CAShapeLayer()
            layer.path = UIBezierPath(roundedRect: CGRect(x: self.view.center.x - self.view.frame.width/4, y: self.view.center.y - self.view.frame.width/4, width: self.view.frame.width/2, height: self.view.frame.width/2), cornerRadius: 25).cgPath
            layer.lineWidth = 2.0
            layer.fillColor = #colorLiteral(red: 1, green: 0.9203630511, blue: 0.7757920394, alpha: 0.1)
            layer.strokeColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)//UIColor.red.cgColor
            let line = CAShapeLayer()
               let linePath = UIBezierPath()
               linePath.move(to: CGPoint(x: self.view.center.x - 50, y: self.view.center.y ))
               linePath.addLine(to: CGPoint(x: self.view.center.x + 50, y: self.view.center.y ))
               line.path = linePath.cgPath
               line.fillColor = nil
               line.opacity = 4.0
               line.strokeColor = UIColor.red.cgColor
            layer.addSublayer(line)
            
            self.avPreviewLayer.addSublayer(layer)
            let subView = UIView()
            subView.layer.addSublayer(self.avPreviewLayer)
            //self.view.layer.addSublayer(self.avPreviewLayer)
            self.view.addSubview(subView)
            subView.snp.makeConstraints { (marker) in
                marker.top.bottom.equalToSuperview().inset(0)
                marker.left.right.equalToSuperview().inset(0)
            }
            //self.avCaptureSession.startRunning()
            configLayout()
        }
  
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
        view.addSubview(detailCode)
        detailCode.backgroundColor = #colorLiteral(red: 0.1725490196, green: 0.2039215686, blue: 0.2745098039, alpha: 1)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        detailCode.layer.cornerRadius = 15
        detailCode.snp.makeConstraints { (marker) in
            marker.bottom.equalToSuperview().inset(-10)
            marker.width.equalTo(self.view.frame.width)
            marker.height.equalTo(self.view.frame.height/3)
            marker.right.left.equalToSuperview().inset(0)
        }
        detailCode.isHidden = true
        // serachingAdress
        findCode.font = UIFont.systemFont(ofSize: 16)
        findCode.numberOfLines = 0
        findCode.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        findCode.layer.borderWidth = 0.5
        findCode.layer.cornerRadius = 10
        findCode.layer.borderColor = #colorLiteral(red: 0.4929717093, green: 0.4929717093, blue: 0.4929717093, alpha: 1)
        findCode.textAlignment  = .center
        detailCode.addSubview(findCode)
       
        findCode.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalToSuperview().inset(10)
            marker.height.equalTo(30)
            marker.width.equalTo(detailCode.frame.width - 10)
            marker.left.right.equalToSuperview().inset(10)
            marker.centerX.equalToSuperview()
        }
        
        imageDetail = UIImage(named: "honor")!
        let uiSub = UIImageView()
        detailCode.addSubview(uiSub)
        uiSub.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(findCode).inset(45)
            marker.height.equalTo(100)
            marker.width.equalTo(60)
            marker.left.equalToSuperview().inset(20)
        }
        uiSub.image = imageDetail
        
        // serachingAdress
        priceCode.font = UIFont.systemFont(ofSize: 16)
        priceCode.numberOfLines = 0
        priceCode.textColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        priceCode.layer.borderWidth = 0.5
        priceCode.layer.cornerRadius = 10
        priceCode.layer.borderColor = #colorLiteral(red: 0.4929717093, green: 0.4929717093, blue: 0.4929717093, alpha: 1)
        priceCode.textAlignment  = .center
        detailCode.addSubview(priceCode)
        priceCode.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(findCode).inset(45)
            marker.height.equalTo(35)
            marker.width.equalTo(75)
            marker.left.equalTo(uiSub).inset(100)
        }
        addPointButton.setTitle("На печать", for: .normal)
        addPointButton.setTitleColor(.white, for: .normal)
        addPointButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        addPointButton.tintColor = .white
        addPointButton.backgroundColor = #colorLiteral(red: 0.7173891844, green: 0.8862745166, blue: 0.5983562226, alpha: 0.8498047077)//#colorLiteral(red: 0.1676526818, green: 0.1903925995, blue: 0.2580723713, alpha: 1)
        addPointButton.layer.cornerRadius = 2
        addPointButton.layer.shadowRadius = 1.5
        addPointButton.layer.shadowColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        detailCode.addSubview(addPointButton)
        //addPointButton.addTarget(self, action: #selector(self.additionalPoint(_:)), for: .touchUpInside)

        addPointButton.snp.makeConstraints { (marker) in
            marker.bottomMargin.equalToSuperview().inset(5)
            marker.top.equalTo(findCode).inset(45)
            marker.height.equalTo(40)
            marker.width.equalTo(100)
            marker.left.equalTo(priceCode).inset(100)
        }
    }
    // layer action
    @objc func layerAction(_ sender:UIButton) {
        dismiss(animated: true)
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
          
           if tabBarTag == true {
            self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 0.2088217232, green: 0.8087635632, blue: 0.364161254, alpha: 1)//UIColor.blue
            self.tabBarController?.tabBar.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)//UIColor.cyan
           } else {
               self.tabBarController?.tabBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
           }
           if (avCaptureSession?.isRunning == false) {
            avCaptureSession.startRunning()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (avCaptureSession?.isRunning == true) {
            avCaptureSession.stopRunning()
        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        avCaptureSession = nil
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension ScannerController : AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        avCaptureSession.stopRunning()
        //runSession()
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
            detailCode.isHidden = true
           // if stringValue == "www.eldorado.ru/cat/detail/71548485/?utm_a=A662" {
           //     findCode.text =  "HONOR 30S (CDY - NX9A)"
           //     priceCode.text = "23 990"
               
          //  } else {
            findCode.text = stringValue
            searchingCode = stringValue
            sheckPrice()
          //  }
            //findCode.text = stringValue
            //let screenCentre : CGPoint = CGPoint(x: self.sceneView.bounds.midX, y: self.sceneView.bounds.midY)
            //let hitTestResults = sceneView.hitTest(screenCentre, types: [.existingPlaneUsingExtent])
           
            /*if let hitResult = hitTestResults.first {
              
              // Get Coordinates of HitTest
              let transform : matrix_float4x4 = hitResult.worldTransform
              let worldCoord : SCNVector3 = SCNVector3Make(transform.columns.3.x, transform.columns.3.y, transform.columns.3.z)
              // Holder node
              let node = SCNNode()
              sceneView.scene.rootNode.addChildNode(node)
              node.position = worldCoord
              let geometry = SCNSphere(radius: 0.01)
              let color = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
              geometry.materials.first?.diffuse.contents = color
              let sphereNode = SCNNode(geometry: geometry)
              node.addChildNode(sphereNode)
              sceneView.scene.rootNode.addChildNode(node)
            } */
        }

        avCaptureSession.startRunning()
        //dismiss(animated: true)
      
    }
    
    func found(code: String) {
        print(code)
    }
    func sheckPrice() {
        //dismiss(animated: true)
        let viewTours = TextDetectController()//ScannerController()
        //startTest.modalTransitionStyle = .flipHorizontal
        viewTours.modalPresentationStyle = .fullScreen
        viewTours.modalTransitionStyle = .crossDissolve
        show(viewTours, sender: self)
        //present(startTest, animated: true, completion: nil)
        print("Launch TextDetect controller")
    }
}
extension ScannerController : ARSCNViewDelegate {
    func runSession() {
            //configuration.worldAlignment = .camera
            configuration.planeDetection = .horizontal
            sceneView.session.run(configuration)
       }
}
// методы session
extension ScannerController {
    
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
