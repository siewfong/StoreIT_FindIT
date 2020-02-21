//
//  newbarcodename.swift
//  Food_FYPJ
//
//  Created by FYPJ on 12/2/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import Foundation
import UIKit

class newbarcodename: UIViewController {
    
    @IBOutlet weak var BarcodeLabel: UILabel!
    @IBOutlet weak var proname: UITextView!
    @IBAction func scanname(_ sender: Any) {
    }
   var barcode:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        BarcodeLabel?.text = barcode
        
    }  
    
}
