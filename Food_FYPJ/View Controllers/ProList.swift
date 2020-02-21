//
//  ProList.swift
//  Food_FYPJ
//
//  Created by FYPJ on 13/2/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit

class ProList: UITableViewCell {
    @IBOutlet weak var Namelabel: UILabel!
    @IBOutlet weak var BarcodeLabel: UILabel!
      
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
