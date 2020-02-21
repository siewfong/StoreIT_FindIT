//
//  KitchenImageViewController.swift
//  Food_FYPJ
//
//  Created by Agnes on 11/2/20.
//  Copyright © 2020 Agnes. All rights reserved.
//
import UIKit
import CTPanoramaView


class KitchenImageViewController: UIViewController {

    @IBOutlet weak var compassView: CTPieSliceView!
    @IBOutlet weak var panoramaView: CTPanoramaView!


    override func viewDidLoad() {
        //Create Tap Gesture
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))

        //Enable image user interaction
        self.panoramaView.isUserInteractionEnabled = true

        //Add Tap gesture to the image
        self.panoramaView.addGestureRecognizer(tapGestureRecognizer)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showCamera),
                                               name: NSNotification.Name("ShowCamera"),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showKitchen),
                                               name: NSNotification.Name("ShowKitchen"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showSignIn),
                                               name: NSNotification.Name("ShowSignIn"),
                                               object: nil)
        super.viewDidLoad()

        loadSphericalImage()
        panoramaView.compass = compassView as? CTPanoramaCompass
    }
    
    
    @objc func showCamera() {
           performSegue(withIdentifier: "ShowCamera", sender: nil)
       }
       
       @objc func showKitchen() {
           performSegue(withIdentifier: "ShowKitchen", sender: nil)
       }
       
       @objc func showSignIn() {
           performSegue(withIdentifier: "ShowSignIn", sender: nil)
       }
           @IBAction func onMenuTapped() {
          print("TOGGLE SIDE MENU")
           NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
       }

    @IBAction func panoramaTypeTapped() {
        if panoramaView.panoramaType == .spherical {
            loadCylindricalImage()
        } else {
            loadSphericalImage()
        }
    }

    @IBAction func motionTypeTapped() {
        if panoramaView.controlMethod == .touch {
            panoramaView.controlMethod = .motion
        } else {
            panoramaView.controlMethod = .touch
        }
    }

    func loadSphericalImage() {
        panoramaView.image = UIImage(named: "spherical")
    }

    func loadCylindricalImage() {
        panoramaView.image = UIImage(named: "cylindrical")
    }
    @objc func tapAction(_ sender: UITapGestureRecognizer){

    //Get the touch point
    let touchPoint = sender.location(in: self.panoramaView)

    //Set the door area
    let cupboard1 = CGRect(x: 200.0, y: 100.0, width: 75.0, height: 100.0)
    
 
        
    //Then check if touch point is near door
    if cupboard1.contains(touchPoint){
        //Peform segue
        performSegue(withIdentifier: "ShowKitchen", sender: nil)
    }
        
    }
    
}
