//
//  ViewController.swift
//  Food_FYPJ
//
//  Created by FYPJ on 14/1/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit
import AVKit

class ViewController: UIViewController {

    var videoPlayer: AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    
    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func setUpElements() {
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }

    
    


}

