//
//  HomeViewController.swift
//  Food_FYPJ
//
//  Created by FYPJ on 14/1/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    @IBOutlet weak var sideMenuConstraint: NSLayoutConstraint!
  var sideMenuOpen = false
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
      NotificationCenter.default.addObserver(self,
                                             selector: #selector(toggleSideMenu),
                                             name: NSNotification.Name("ToggleSideMenu"),
                                             object: nil)
  }
  
  @objc func toggleSideMenu() {
      if sideMenuOpen {
          sideMenuOpen = false
          sideMenuConstraint.constant = -240
          
      } else {
          sideMenuOpen = true
          sideMenuConstraint.constant = 0
      }
      UIView.animate(withDuration: 0.3) {
          self.view.layoutIfNeeded()
      }
  }
    

    
}
