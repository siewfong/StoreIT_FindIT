//
//  productlist.swift
//  Food_FYPJ
//
//  Created by FYPJ on 13/2/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit

class productlist: NSObject {
    var Name: String
    var Barcode: String
    var EDate: String
    var PDate: String
     
init(Name: String, Barcode: String, EDate: String, PDate: String)
     
{
    self.Name = Name
     
self.Barcode = Barcode
    self.EDate = EDate
     
    self.PDate = PDate
    }
     
}
