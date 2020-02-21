//
//  barcode.swift
//  Food_FYPJ
//
//  Created by FYPJ on 7/2/20.
//  Copyright © 2020 Agnes. All rights reserved.
//


import UIKit
import AVFoundation
import Vision
import Firebase
import VisionKit

class barcode: UIViewController, AVCapturePhotoCaptureDelegate,VNDocumentCameraViewControllerDelegate {

    @IBOutlet weak var previewContainer: UIView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var CatDetailsTextView: UITextView!
    //var shutterButton: UIButton!
    
    
    
    var captureOutput: AVCapturePhotoOutput?
    var productCatalog = ProductCatalog()
      var textRecognitionRequest = VNRecognizeTextRequest()
      var recognizedText = ""
  var barcodeText = ""

   
    private var captureSession: AVCaptureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "Capture Session Queue")
    
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
   self.navigationController?.setNavigationBarHidden(false, animated: true)
   self.title = "Barcode Scanning"
   
   textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
       if let results = request.results, !results.isEmpty {
           if let requestResults = request.results as? [VNRecognizedTextObservation] {
               self.recognizedText = ""
               for observation in requestResults {
                   guard let candidiate = observation.topCandidates(1).first else { return }
                   self.recognizedText += candidiate.string
                   self.recognizedText += "\n"
               }
               self.CatDetailsTextView.text = self.recognizedText
           }
       }
   })
   textRecognitionRequest.recognitionLevel = .accurate
   textRecognitionRequest.usesLanguageCorrection = false
   textRecognitionRequest.customWords = ["@gmail.com", "@outlook.com", "@yahoo.com", "@icloud.com"]
        

        
        
        
        
        checkPermissions()
        setupCaptureSession()
       // addShutterButton()
    }
   
       
func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
              let image = scan.imageOfPage(at: 0)
              let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
              do {
                  try handler.perform([textRecognitionRequest])
              } catch {
                  print(error)
              }
              controller.dismiss(animated: true)
          }
    private func setupCaptureSession() {
        sessionQueue.sync {
            self.captureSession.beginConfiguration()
            
            let output = AVCaptureMetadataOutput()
            
            if let device = AVCaptureDevice.default(for: .video),
                let input = try? AVCaptureDeviceInput(device: device),
                self.captureSession.canAddInput(input) && self.captureSession.canAddOutput(output) {
                self.captureSession.addInput(input)
                self.captureSession.addOutput(output)
                captureOutput = AVCapturePhotoOutput()
                captureOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
                       captureSession.addOutput(captureOutput!)
                output.metadataObjectTypes = [
                    .aztec,
                    .code39,
                    .code39Mod43,
                    .code93,
                    .code39Mod43,
                    .code128,
                    .dataMatrix,
                    .ean8,
                    .ean13,
                    .interleaved2of5,
                    .itf14,
                    .interleaved2of5,
                    .pdf417,
                    .qr,
                    .upce
                ]
                
                output.setMetadataObjectsDelegate(self as! AVCaptureMetadataOutputObjectsDelegate, queue: DispatchQueue.main)
            }
            
            self.captureSession.commitConfiguration()
            
            DispatchQueue.main.async {
                self.setupPreviewLayer(session: self.captureSession)
                self.setupBoundingBox()
            }
            
            self.captureSession.startRunning()
        }
    }
   /* @objc func captureImage() {
        let settings = AVCapturePhotoSettings()
        captureOutput?.capturePhoto(with: settings, delegate: self)
    }*/
    // MARK: - User interface
       private func displayNotAuthorizedUI() {
           let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width * 0.8, height: 20))
           label.textAlignment = .center
           label.numberOfLines = 0
           label.lineBreakMode = .byWordWrapping
           label.text = "Please grant access to the camera for scanning barcodes."
           label.sizeToFit()

           let button = UIButton(frame: CGRect(x: 0, y: label.frame.height + 8, width: view.frame.width * 0.8, height: 35))
           button.layer.cornerRadius = 10
           button.setTitle("Grant Access", for: .normal)
           button.backgroundColor = UIColor(displayP3Red: 4.0/255.0, green: 92.0/255.0, blue: 198.0/255.0, alpha: 1)
           button.setTitleColor(.white, for: .normal)
           button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)

           let containerView = UIView(frame: CGRect(
               x: view.frame.width * 0.1,
               y: (view.frame.height - label.frame.height + 8 + button.frame.height) / 2,
               width: view.frame.width * 0.8,
               height: label.frame.height + 8 + button.frame.height
               )
           )
           containerView.addSubview(label)
           containerView.addSubview(button)
           view.addSubview(containerView)
       }
    private func checkPermissions() {
        let mediaType = AVMediaType.video
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)

        switch status {
        case .denied, .restricted:
            displayNotAuthorizedUI()
        case.notDetermined:
            // Prompt the user for access.
            AVCaptureDevice.requestAccess(for: mediaType) { granted in
                guard granted != true else { return }

                // The UI must be updated on the main thread.
                DispatchQueue.main.async {
                    self.displayNotAuthorizedUI()
                }
            }

        default: break
        }
    }
    
    @objc private func openSettings() {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL) { _ in
            self.checkPermissions()
        }
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData) {

            // Convert image to CIImage.
            guard let ciImage = CIImage(image: image) else {
                fatalError("Unable to create \(CIImage.self) from \(image).")
            }

            // Perform the classification request on a background thread.
            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation.up, options: [:])

                do {
                    try handler.perform([self.detectBarcodeRequest])
                } catch {
                    self.showAlert(withTitle: "Error Decoding Barcode", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func setupPreviewLayer(session: AVCaptureSession) {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = previewContainer.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        previewContainer.layer.addSublayer(previewLayer)
    }
    
    // MARK - Bounding Box
    private var boundingBox = CAShapeLayer()
    private func setupBoundingBox() {
        boundingBox.frame = previewContainer.layer.bounds
        boundingBox.strokeColor = UIColor.red.cgColor
        boundingBox.lineWidth = 4.0
        boundingBox.fillColor = UIColor.clear.cgColor
        
        previewContainer.layer.addSublayer(boundingBox)
    }
    
    fileprivate func updateBoundingBox(_ points: [CGPoint]) {
        guard let firstPoint = points.first else {
            return
        }
        
        let path = UIBezierPath()
        path.move(to: firstPoint)
        
        var newPoints = points
        newPoints.removeFirst()
        newPoints.append(firstPoint)
        
        newPoints.forEach { path.addLine(to: $0) }
        
        boundingBox.path = path.cgPath
        boundingBox.isHidden = false
    }
    
    private var resetTimer: Timer?
    fileprivate func hideBoundingBox(after: Double) {
        resetTimer?.invalidate()
        resetTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval() + after,
                                          repeats: false) {
                                            [weak self] (timer) in
                                            self?.resetViews() }
    }
    
    private func resetViews() {
        boundingBox.isHidden = true
        resultsLabel.text = nil
    }
  /* private func addShutterButton() {
           let width: CGFloat = 75
           let height = width
           shutterButton = UIButton(frame: CGRect(x: (view.frame.width - width) / 2,
                                                  y: view.frame.height - height - 200,
                                                  width: width,
                                                  height: height
               )
           )
           shutterButton.layer.cornerRadius = width / 2
           shutterButton.backgroundColor = UIColor.init(displayP3Red:0, green:0, blue: 0, alpha: 1)
           shutterButton.showsTouchWhenHighlighted = true
           shutterButton.addTarget(self, action: #selector(captureImage), for: .touchUpInside)
           view.addSubview(shutterButton)
       }*/
       @IBAction func shutterButton(_ sender: Any) {
        
           captureImage()
        
       }
       

          override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "barcodename" {
               let vc = segue.destination as! namebarcodeViewController
            vc.barcodeLabel = self.resultsLabel.text ?? "123"
            print(vc.barcodeLabel)
      
           } else if segue.identifier == "barcodeE" {
               let vc = segue.destination as! CameraViewController
            let db = Firestore.firestore()
            let barcodeRef = db.collection("Barcode").document(resultsLabel.text ?? "123")
            barcodeRef.getDocument{ (document, error) in
                if let document = document {
                    if document.exists{
                    let nameofpro = document.get("Name") as! String
                        vc.barcodesLabel = document.documentID
                        vc.nameofPro = nameofpro
                   // print (document.documentID, nameofpro)
                    
                }
                }
                
            }
           }
    
           
       }
 
    
    private func showInfo(){
    
        let db = Firestore.firestore()
        self.barcodeText = self.resultsLabel.text!
        let barcodeRef = db.collection("Barcode").document(resultsLabel.text!)
                barcodeRef.getDocument { (document, error) in
                if let document = document {
                    if document.exists{
                    let nameofpro = document.get("Name") as! String
                         self.performSegue(withIdentifier: "barcodeE", sender: nil)
                    self.showAlert(withTitle: nameofpro, message: "")
                       
                }
                else{
                        
                    self.performSegue(withIdentifier: "barcodename", sender: nil)
                    self.showAlert(withTitle: "Non existence", message: "")
                     
                        
                }
                    
                    }
                    
            }
        
    }
        
   
        //barcodeRef.getDocuments { (querySnapshot, err) in
         //   if let docs = querySnapshot?.documents {
            //    for docSnapshot in docs {
                    //This is how to get the documentID print(docSnapshot.documentID)
                  // if docSnapshot.documentID == self.resultsLabel.text {
               //     print(docSnapshot.documentID)
                        /*let query = db.collection("Barcode").whereField(docSnapshot.documentID, isEqualTo: self.resultsLabel.text!)
                        query.getDocuments { (querySnapshot, err) in
                            if let docs = querySnapshot?.documents {
                                for docSnapshot in docs {
                                    print(docSnapshot.data())
                                }
                            }
                        }*/
                    //}
                   // else {
                 //   db.collection("Barcode").document(self.resultsLabel.text ?? "123").setData(["name of product": self.CatDetailsTextView.text])
                   //     showAlert(withTitle: "barcode added", message: "")
                    
            
            
        
        
        
        
        /*
        
        
           if let product = productCatalog.item(forKey: payload) {
               print(payload)
               showAlert(withTitle: product.name ?? "No product name provided", message: payload)
          
        
           } else {
           
        db.collection("Barcode").document(resultsLabel.text!).setData(["name of product": CatDetailsTextView.text!])
            let Productcam = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            self.navigationController?.pushViewController(Productcam, animated: true)
            showAlert(withTitle: "Items added", message: "")
           }*/
       
    @objc func captureImage() {
        let settings = AVCapturePhotoSettings()
        captureOutput?.capturePhoto(with: settings, delegate: self)
    }
    lazy var detectBarcodeRequest: VNDetectBarcodesRequest = {
           return VNDetectBarcodesRequest(completionHandler: {(request, error) in
               guard error == nil else{
                   self.showAlert(withTitle:"Barcode Error", message: error!.localizedDescription)
                   return
               }
               self.processClassification(for: request)
           })
       }()
    // MARK: - Vision
      func processClassification(for request: VNRequest) {
          DispatchQueue.main.async {
              if let bestResult = request.results?.first as? VNBarcodeObservation,
                  let payload = bestResult.payloadStringValue {
                  self.showInfo()
              } else {
                  self.showAlert(withTitle: "Unable to extract results",
                                 message: "Cannot extract barcode information from data.")
              }
          }
      }
      
    
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}

extension barcode: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            self.resultsLabel.text = object.stringValue
            
            guard let transformedObject = previewLayer.transformedMetadataObject(for: object) as? AVMetadataMachineReadableCodeObject else {
                return
            }
            
            updateBoundingBox(transformedObject.corners)
            hideBoundingBox(after: 0.25)
        }
    }
}


