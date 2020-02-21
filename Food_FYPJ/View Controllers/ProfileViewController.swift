
//
//  Created by Sai Kambampati on 8/21/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import UIKit
import VisionKit
import Vision
import Firebase

class CatProfileViewController: UIViewController, VNDocumentCameraViewControllerDelegate {
  
  //  var refproduct: DatabaseReference!
    //https://www.youtube.com/watch?v=zgVW3s9W88k
    @IBOutlet weak var Pdate: UIDatePicker!
    
    @IBOutlet weak var edateTF: UITextField!
    @IBOutlet weak var pdateTF: UITextField!
    @IBOutlet weak var NameofPro: UILabel!
    @IBOutlet weak var BarcodeLabel: UILabel!
    @IBOutlet weak var EDate: UIDatePicker!
    
    @IBOutlet weak var BarCode: UIButton!
    @IBOutlet weak var CatImageView: UIImageView!
    //@IBOutlet weak var CatDetailsTextView: UITextView!
   
    var catImage: UIImage!
    var BC =  ""
    var nameofPro = ""
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""

    override func viewDidLoad() {
          
          // NameofPro.text = nameofPro
           
           super.viewDidLoad()
           self.navigationController?.setNavigationBarHidden(false, animated: true)
           self.title = "New Item"
           BarcodeLabel.text = BC
           NameofPro.text = nameofPro
           CatImageView.image = catImage
       
       }
    
   
    @IBAction func AddItem(_ sender: Any) {
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "dd-MM-yyyy"
              
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let result = formatter.string(from: date)
        edateTF.text = dateFormatter.string(from: EDate.date)
        pdateTF.text = dateFormatter.string(from: Pdate.date)
    
        if edateTF.text! > result {
            let db = Firestore.firestore()
            db.collection("FoodCollection").document().setData(
                ["Name": NameofPro.text!, "Barcode": BarcodeLabel.text!, "Expiry Date": edateTF.text!, "Production Date": pdateTF.text!,"Date of entry": date])
             performSegue(withIdentifier: "End", sender: nil)
            showAlert(withTitle: "Data entered successfully", message: "")
           
        }
        else if pdateTF.text! > result {
            showAlert(withTitle: "Production date must be after today!", message: "")
        }
        else {
            showAlert(withTitle: "Expiry date is less than today !", message: "")
        }
    
    
    }
     private func showAlert(withTitle title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }
   

