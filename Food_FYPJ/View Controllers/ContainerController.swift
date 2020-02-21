//
//  ContainerController.swift
//  Food_FYPJ
//
//  Created by FYPJ on 16/1/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func configureHomeController() {
        let homeController = HomeViewController()
        let controller = UINavigationController(rootViewController: homeController)
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
    }
    
    func configureMenuController() {
        
    }
    
    
}
