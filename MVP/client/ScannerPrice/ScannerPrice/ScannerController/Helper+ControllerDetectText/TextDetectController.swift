//
//  TextDetectController.swift
//  ScannerPrice
//
//  Created by Артем Стратиенко on 23.06.2021.
//

import UIKit
import Vision
import AVFoundation
import SnapKit

class TextDetectController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    //
    var imageView = UIImageView()
    var session = AVCaptureSession()
    var requests = [VNRequest]()
    let layerButton = UIButton(type: .system)
    let printButton = UIButton(type: .system)
    //Request for text recognition
    var textRecognitionRequest: VNRecognizeTextRequest?
    //Recognition queue
    let textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    
    private var loader: UIView?
    private var textBlocks = [RecognizedTextBlock]()
    private var invoiceImage: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setTextRequest()
        //setInvoicesTapRecognizer()
        configurationLayout()
        startLiveVideo()
        startTextDetection()
    }
    func configurationLayout() {
        view.addSubview(imageView)
        imageView.snp.makeConstraints { (marker) in
            marker.left.right.equalToSuperview().inset(0)
            marker.top.equalToSuperview().inset(0)
            marker.bottom.equalToSuperview().inset(0)
        }
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
        let printButtonColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        // layer
        //layerButton.setImage(UIImage(named: "layer_nf_x"), for: .normal)
        printButton.setTitle("печать", for: .normal)
        printButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10)
        printButton.tintColor = .white
        printButton.backgroundColor = printButtonColor
        printButton.layer.cornerRadius = 10
        printButton.isHidden = true
        view.addSubview(printButton)
        printButton.addTarget(self, action: #selector(self.layerAction(_:)), for: .touchUpInside)
        printButton.snp.makeConstraints { (marker) in
            marker.height.equalTo(40)
            marker.width.equalTo(80)
            marker.bottom.equalToSuperview().inset(40)
            marker.rightMargin.equalToSuperview().inset(5)
        }
    }
    @objc func layerAction(_ sender:UIButton) {
        for qr in eldo {
            if qr.qrcode == searchingCode {
                productCall.addProduct(eldoProduct: qr)
            }
        }
        dismiss(animated: true)
    }
    func startLiveVideo() {
        //1
        session.sessionPreset = AVCaptureSession.Preset.photo
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        //2
        let deviceInput = try! AVCaptureDeviceInput(device: captureDevice!)
        let deviceOutput = AVCaptureVideoDataOutput()
        deviceOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        deviceOutput.setSampleBufferDelegate(self, queue: DispatchQueue.global(qos: DispatchQoS.QoSClass.default))
        session.addInput(deviceInput)
        session.addOutput(deviceOutput)
        
        //3
        let imageLayer = AVCaptureVideoPreviewLayer(session: session)
        imageLayer.frame = imageView.bounds
        imageView.layer.addSublayer(imageLayer)
        
        session.startRunning()
    }
    override func viewDidLayoutSubviews() {
        imageView.layer.sublayers?[0].frame = imageView.bounds
    }
    func startTextDetection() {
        let test = VNRecognizeTextRequest(completionHandler: self.detectTextHandler)
        //let textRequest = VNDetectTextRectanglesRequest(completionHandler: self.detectTextHandler)
        //textRequest.reportCharacterBoxes = true
        //Individual recognition request settings
        test.minimumTextHeight = 0.050//0.011 // Lower = better quality
        test.recognitionLevel = .accurate
        test.recognitionLanguages = ["en_US"]
        self.requests = [test]
    }
    
    func detectTextHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results else {
            print("no result")
            return
        }
        
        let result = observations.map({$0 as? VNRecognizedTextObservation})
        //let frame = observations.map({$0 as? VNTextObservation})
        DispatchQueue.main.async() {
            self.imageView.layer.sublayers?.removeSubrange(1...)
            
        }
        var index = 0
        for observation in result {
            index += 1
           
            guard let topCandidate = observation!.topCandidates(1).first else { continue }
            if let recognizedBlock = self.getRecognizedDoubleBlock(topCandidate: topCandidate.string, observationBox: observation!.boundingBox) {
                
                self.textBlocks.append(recognizedBlock)
                print(topCandidate.string)
                let searchPrice = topCandidate.string
                
                //if frame[index] != nil {
                //}
                //highlightWord(box: observation!)
                DispatchQueue.main.async { [self] in
                    highlightWord(box: observation!)
                    print("search price\(searchPrice)")
                    if let price = Double(searchPrice)  {
                        print("op: \(price)")
                        if price != 10990.0 {
                            printButton.isHidden = false
                        }
                    } else {
                        printButton.isHidden = false
                    }
                    // drawRecognizedBlocks()
                }
            }
        }
        
    }
    
    func highlightWord(box: VNRecognizedTextObservation) {
   
        
        var maxX: CGFloat = 9999.0
        var minX: CGFloat = 0.0
        var maxY: CGFloat = 9999.0
        var minY: CGFloat = 0.0
        
   
            if box.bottomLeft.x < maxX {
                maxX = box.bottomLeft.x
            }
            if box.bottomRight.x > minX {
                minX = box.bottomRight.x
            }
            if box.bottomRight.y < maxY {
                maxY = box.bottomRight.y
            }
            if box.topRight.y > minY {
                minY = box.topRight.y
            }
        
        let xCord = maxX * imageView.frame.size.width
        let yCord = (1 - minY) * imageView.frame.size.height
        let width = (minX - maxX) * imageView.frame.size.width
        let height = (minY - maxY) * imageView.frame.size.height
        
        let outline = CALayer()
        outline.frame = CGRect(x: xCord, y: yCord, width: width, height: height)
        outline.borderWidth = 5.0
        outline.borderColor = #colorLiteral(red: 1, green: 0, blue: 0.5640890044, alpha: 1)//UIColor.red.cgColor
        
        imageView.layer.addSublayer(outline)
    }
    func getRecognizedDoubleBlock(topCandidate: String, observationBox: CGRect) -> RecognizedTextBlock? {
        //Text blocks settings for this project
        var finalString = topCandidate.replacingOccurrences(of: ",", with: ".")
        let restrictedSymbols: Set<Character> = ["=", "-", "_", "+", " "]
        finalString.removeAll(where: { restrictedSymbols.contains($0) })
        for _ in 0 ..< 3 {
            if let lastCharacter = finalString.last, !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: String(lastCharacter))) {
                finalString.removeLast()
            }
        }
        
        //Only Doubles for this project
        //if let double = Double(finalString) {
        let value = Double(finalString)
        print("Double control \(value)")
        if value != nil {
            return RecognizedTextBlock(doubleValue: value!/*double*/, recognizedRect: observationBox)
        } else {
            return nil
        }
        
        //}
        //return nil
    }
    func drawRecognizedBlocks() {
        //guard let image = imageView?.image else  { return }
        
        //transform from documentation
        let imageTransform = CGAffineTransform.identity.scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -imageView.bounds.size.height).scaledBy(x: imageView.bounds.size.width, y: imageView.bounds.size.height)
        
        //drawing rects on cgimage
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()!
        imageView.draw(CGRect(origin: .zero, size: imageView.bounds.size))
        context.setStrokeColor(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)/*CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)*/)
        context.setLineWidth(3)
        context.setFillColor(#colorLiteral(red: 0.7982461688, green: 0.6604653427, blue: 1, alpha: 0.75))
        
        var widtPrice = textBlocks.first?.recognizedRect.size.width
        for block in textBlocks {
            if block.recognizedRect.size.width > widtPrice! {
                widtPrice = block.recognizedRect.size.width
            }
        }
        for index in 0 ..< textBlocks.count {
            if textBlocks[index].recognizedRect.size.width == widtPrice {
                context.setStrokeColor(#colorLiteral(red: 1, green: 0.446985569, blue: 0.7495446126, alpha: 1))
            } else {
                context.setStrokeColor(#colorLiteral(red: 0.6304002535, green: 0.336029062, blue: 1, alpha: 1))
            }
            let optimizedRect = textBlocks[index].recognizedRect.applying(imageTransform)
            context.addRect(optimizedRect)
            textBlocks[index].imageRect = optimizedRect
            context.strokePath()
        }
        //context.strokePath()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        imageView.image = result
    }
}

extension TextDetectController {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        var requestOptions:[VNImageOption : Any] = [:]
        
        if let camData = CMGetAttachment(sampleBuffer, key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix, attachmentModeOut: nil) {
            requestOptions = [.cameraIntrinsics:camData]
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: CGImagePropertyOrientation(rawValue: 6)!, options: requestOptions)
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
}
/*
//MARK: Recognition block
private extension MainViewController {
    
    //Call text recognition request handler
    func recognizeImage(cgImage: CGImage) {
        textRecognitionWorkQueue.async {
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest!])
            } catch {
                DispatchQueue.main.async {
                    self.removeLoader()
                    print(error)
                }
            }
        }
    }
    
    //Set textRecognitionRequest from ViewDidLoad
    func setTextRequest() {
        textRecognitionRequest = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                return
            }
            var detectedText = ""
            self.textBlocks.removeAll()
            
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                //detectedText += "\(topCandidate.string) :: rect :: width \(observation.boundingBox.size.width)\n"
                detectedText += "\(topCandidate.string) :: rect :: width \(observation.boundingBox.size.width)\n"
                //Text block specific for this project
                if let recognizedBlock = self.getRecognizedDoubleBlock(topCandidate: topCandidate.string, observationBox: observation.boundingBox) {
                    detectedText += "\(topCandidate.string) :: rect :: width \(observation.boundingBox.size.width)\n"
                    self.textBlocks.append(recognizedBlock)
                }
            }
        }
        
        //Individual recognition request settings
        textRecognitionRequest!.minimumTextHeight = 0.011 // Lower = better quality
        textRecognitionRequest!.recognitionLevel = .accurate
        textRecognitionRequest!.recognitionLanguages = ["en_US"]
    }
    
    func drawRecognizedBlocks() {
        guard let image = invoiceImage?.image else  { return }
        
        //transform from documentation
        let imageTransform = CGAffineTransform.identity.scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -image.size.height).scaledBy(x: image.size.width, y: image.size.height)
        
        //drawing rects on cgimage
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()!
        image.draw(in: CGRect(origin: .zero, size: image.size))
        context.setStrokeColor(#colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)/*CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)*/)
        context.setLineWidth(3)
        context.setFillColor(#colorLiteral(red: 0.7982461688, green: 0.6604653427, blue: 1, alpha: 0.75))
        
        var widtPrice = textBlocks.first?.recognizedRect.size.width
        for block in textBlocks {
            if block.recognizedRect.size.width > widtPrice! {
                widtPrice = block.recognizedRect.size.width
            }
        }
        for index in 0 ..< textBlocks.count {
            if textBlocks[index].recognizedRect.size.width == widtPrice {
                context.setStrokeColor(#colorLiteral(red: 1, green: 0.446985569, blue: 0.7495446126, alpha: 1))
            } else {
                context.setStrokeColor(#colorLiteral(red: 0.6304002535, green: 0.336029062, blue: 1, alpha: 1))
            }
            let optimizedRect = textBlocks[index].recognizedRect.applying(imageTransform)
            context.addRect(optimizedRect)
            textBlocks[index].imageRect = optimizedRect
            context.strokePath()
        }
        //context.strokePath()
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        invoiceImage?.image = result
    }
    
    //UIImageView tap listener
    @objc func onImageViewTap(sender: UITapGestureRecognizer) {
        guard let invoiceImage = invoiceImage, let image = invoiceImage.image else {
            return
        }
        
        //get tap coordinates on image
        let tapX = sender.location(in: invoiceImage).x
        let tapY = sender.location(in: invoiceImage).y
        let xRatio = image.size.width / invoiceImage.bounds.width
        let yRatio = image.size.height / invoiceImage.bounds.height
        let imageXPoint = tapX * xRatio
        let imageYPoint = tapY * yRatio

        //detecting if one of text blocks tapped
        var widtPrice = textBlocks.first?.recognizedRect.size.width
        var descriptionObject = ""
        for block in textBlocks {
            if block.recognizedRect.size.width > widtPrice! {
                widtPrice = block.recognizedRect.size.width
            }
        }
        for block in textBlocks {
            
            if block.imageRect.contains(CGPoint(x: imageXPoint, y: imageYPoint)) {
                if block.recognizedRect.size.width == widtPrice {
                    descriptionObject = "Стоимость"
                } else {
                    descriptionObject = "Артикул"
                }
                showTapAlert(doubleValue: block.doubleValue,descriptionObject)
                break
            }
        }
    }
}

//MARK: UIKit block
private extension MainViewController {
    func setInvoicesTapRecognizer() {
        for imageView in stackOfInvoices.arrangedSubviews {
            imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onStackInvoiceTap(sender:))))
        }
    }
    
    @objc func onStackInvoiceTap(sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView, let newImage = imageView.image, let cgImage = newImage.cgImage else {
            return
        }
        setLoader()
        self.textView.text = ""
        addNewInvoiceImageView(with: newImage)
        recognizeImage(cgImage: cgImage)
    }
    
    
    
    func showTapAlert(doubleValue: Double,_ desc : String) {
        let alert = UIAlertController(title: "Описание обьекта!", message: "\(desc) : \(doubleValue)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setLoader() {
        loader = UIView(frame: view.bounds)
        loader?.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)//UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        let activity = UIActivityIndicatorView(style: .large)
        activity.startAnimating()
        loader?.addSubview(activity)
        
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.centerXAnchor.constraint(equalTo: loader!.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: loader!.centerYAnchor).isActive = true
        
        view.addSubview(loader!)
    }
    
    func removeLoader() {
        loader?.removeFromSuperview()
        loader = nil
    }
    
    func getRecognizedDoubleBlock(topCandidate: String, observationBox: CGRect) -> RecognizedTextBlock? {
        //Text blocks settings for this project
        var finalString = topCandidate.replacingOccurrences(of: ",", with: ".")
        let restrictedSymbols: Set<Character> = ["=", "-", "_", "+", " "]
        finalString.removeAll(where: { restrictedSymbols.contains($0) })
        for _ in 0 ..< 3 {
            if let lastCharacter = finalString.last, !CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: String(lastCharacter))) {
                finalString.removeLast()
            }
        }
        
        //Only Doubles for this project
        //if let double = Double(finalString) {
        let value = Double(finalString)
        
        if value != nil {
            return RecognizedTextBlock(doubleValue: value!/*double*/, recognizedRect: observationBox)
        } else {
            return nil
        }
        
        //}
        //return nil
    }
}
*/

