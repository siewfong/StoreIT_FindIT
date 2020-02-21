//
//  ViewProductViewController.swift
//  Food_FYPJ
//
//  Created by FYPJ on 13/2/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit
import Firebase

class ViewProductViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
  
   
    @IBOutlet weak var tableView: UITableView!
    
    var ProductList : [productlist] = []
     let headers:[String] = ["Expiring","Non-Expiring"]
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let barcodeRef = Firestore.firestore().collection("FoodCollection")
        barcodeRef.addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
               let nameofpro = document.get("Name") as! String
                let barcode = document.get("Barcode") as! String
                let edate = document.get("Expiry Date") as! String
                let pdate = document.get("Production Date") as! String
               
                self.ProductList.append(productlist(Name: nameofpro, Barcode: barcode, EDate: edate, PDate: pdate))
            }
            }
        /*barcodeRef.getDocument { (document, error) in
            if let document = document {
                if document.exists{
                let nameofpro = document.get("Name") as! String
                let barcode = document.get("Barcode") as! String
                let edate = document.get("Expiry Date") as! String
                let pdate = document.get("Production Date") as! String
               
                self.ProductList.append(productlist(Name: nameofpro, Barcode: barcode, EDate: edate, PDate: pdate))
            }
        }
        }
        */
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headers[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductList.count
      }
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return ProductList.count
    }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "ProList", for: indexPath) as! ProList
        cell.Namelabel.text = ProductList[indexPath.section].Name
               cell.BarcodeLabel.text = ProductList[indexPath.section].Barcode
               return cell
       }
    

}
