//
//  TableTableViewController.swift
//  Food_FYPJ
//
//  Created by FYPJ on 17/1/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit

class TableTableViewController: UITableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        switch indexPath.row {
        case 0: NotificationCenter.default.post(name: NSNotification.Name("ShowCamera"), object: nil)
        case 1: NotificationCenter.default.post(name: NSNotification.Name("ShowKitchen"), object: nil)
        case 2: NotificationCenter.default.post(name: NSNotification.Name("ShowSignIn"), object: nil)
        default: break
        }
    }
}
