//
//  namebarcodeViewController.swift
//  Food_FYPJ
//
//  Created by FYPJ on 12/2/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit
import Vision
import VisionKit
import Firebase

class namebarcodeViewController: UIViewController,VNDocumentCameraViewControllerDelegate{

    @IBOutlet weak var barcodelabel: UILabel!
    @IBOutlet weak var pronamelabel: UILabel!
    @IBOutlet weak var productTF: UITextField!
   // var barcodeText = ""
    var barcodeLabel = "" //barcode 
    //var NameofPro = ""
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barcodelabel.text = barcodeLabel
    
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    self.recognizedText = ""
                    for observation in requestResults {
                        guard let candidiate = observation.topCandidates(1).first else { return }
                        self.recognizedText += candidiate.string
                        self.recognizedText += "\n"
                    }
                    self.productTF.text = self.recognizedText
                }
            }
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = ["@gmail.com", "@outlook.com", "@yahoo.com", "@icloud.com"]
        // Do any additional setup after loading the view.
    }

       /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.identifier == "barcodeE" {
            let vc = segue.destination as! CameraViewController
            vc.barcodesLabel = self.barcodelabel.text!
            vc.nameofPro = self.productTF.text!
            }
       
        
    }*/
    
    @IBAction func AddBarcode(_ sender: Any) {
       // self.barcodeText = self.barcodelabel.text!
       // self.NameofPro = self.pronamelabel.text!
        let db = Firestore.firestore()
        db.collection("Barcode").document(barcodelabel.text ?? "123").setData(["Name": productTF.text!])
        self.performSegue(withIdentifier: "barcodeNexist", sender: nil)
        self.showAlert(withTitle: "Item added to your database successfully", message: "")
        
    }
    @IBAction func scanDocument(_ sender: Any) {
        // Use VisionKit to scan business cards
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        self.present(documentCameraViewController, animated: true, completion: nil)
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
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true)
    }
}
