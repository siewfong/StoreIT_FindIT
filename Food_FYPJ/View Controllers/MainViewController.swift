//
//  MainViewController.swift
//  Food_FYPJ
//
//  Created by FYPJ on 17/1/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import UIKit
import Image360


let picture1URL = Bundle.main.url(forResource: "picture1", withExtension: "jpg")!
let picture2URL = Bundle.main.url(forResource: "picture2", withExtension: "jpg")!


class MainViewController: UIViewController {
 
    @IBOutlet weak var angleXZSlider: UISlider!
    @IBOutlet weak var angleYSlider: UISlider!
    @IBOutlet weak var fovSlider: UISlider!
    @IBOutlet var image360Controller: Image360Controller!

    @IBOutlet weak var Image: UIView!
    @IBOutlet var pictureSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    

     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if let identifier = segue.identifier {
               switch identifier {
               case "image360":
                   if let destination = segue.destination as? Image360Controller {
                       self.image360Controller = destination
                       self.image360Controller.imageView.observer = self
                   }
               case "settings":
                   if let destination = segue.destination as? SettingsController {
                       destination.inertia = image360Controller.inertia
                       destination.pictureIndex = pictureSegmentedControl.selectedSegmentIndex
                       destination.isOrientationViewHidden = image360Controller.isOrientationViewHidden
                   }
               default:
                   ()
               }
           }
       }

      override func viewDidAppear(_ animated: Bool) {
              super.viewDidAppear(animated)
              if pictureSegmentedControl.selectedSegmentIndex < 0 {
                  pictureSegmentedControl.selectedSegmentIndex = 0
             //     segmentChanged(sender: pictureSegmentedControl)
              }
          }


       @IBAction func unwindToViewController(segue: UIStoryboardSegue) {
            guard let settingsController = segue.source as? SettingsController else {
                assertionFailure("Unexpected controller's type")
                return
            }
            image360Controller.inertia = settingsController.inertia
            pictureSegmentedControl.selectedSegmentIndex = settingsController.pictureIndex
            image360Controller.isOrientationViewHidden = settingsController.isOrientationViewHidden
         //   segmentChanged(sender: pictureSegmentedControl)
        }
     /*  @IBAction func segmentChanged(sender: UISegmentedControl) {
           let pictureURL: URL
           switch sender.selectedSegmentIndex {
           case 0:
               pictureURL = picture1URL
           case 1:
               pictureURL = picture2URL
           default:
               assertionFailure("Unexpected selected segment index")
               return
           }

           do {
               let data = try Data(contentsOf: pictureURL)
               if let image = UIImage(data: data) {
                   self.image360Controller.image = image
               } else {
                   NSLog("liveView - frameData is not image")
               }
           } catch  {

           }
       }*/

       @IBAction func angleXZSliderChanged(sender: UISlider) {
           image360Controller.imageView.observer = nil
           let imageView = image360Controller.imageView
           let newRotationAngleXZ = (imageView.rotationAngleXZMax - imageView.rotationAngleXZMin) * sender.value + imageView.rotationAngleXZMin
           image360Controller.imageView.setRotationAngleXZ(newValue: newRotationAngleXZ)
        image360Controller.imageView.observer = self as Image360ViewObserver
       }

       @IBAction func angleYSliderChanged(sender: UISlider) {
           image360Controller.imageView.observer = nil
           let imageView = image360Controller.imageView
           let newRotationAngleY = (imageView.rotationAngleYMax - imageView.rotationAngleYMin) * sender.value + imageView.rotationAngleYMin
           image360Controller.imageView.setRotationAngleY(newValue: newRotationAngleY)
        image360Controller.imageView.observer = self as Image360ViewObserver
       }

       @IBAction func fovSliderChanged(sender: UISlider) {
           image360Controller.imageView.observer = nil
           let imageView = image360Controller.imageView
           let newFOV = (imageView.cameraFOVDegreeMax - imageView.cameraFOVDegreeMin) * sender.value + imageView.cameraFOVDegreeMin
           image360Controller.imageView.setCameraFovDegree(newValue: newFOV)
        image360Controller.imageView.observer = self as Image360ViewObserver
       }
   }

   // MARK: - Image360ViewObserver
   extension MainViewController: Image360ViewObserver {
       func image360View(_ view: Image360View, didChangeFOV cameraFov: Float) {

       }

       func image360View(_ view: Image360View, didRotateOverY rotationAngleY: Float) { angleYSlider.value = (rotationAngleY - view.rotationAngleYMin) / (view.rotationAngleYMax - view.rotationAngleYMin)
       }

       func image360View(_ view: Image360View, didRotateOverXZ rotationAngleXZ: Float) { angleXZSlider.value = (rotationAngleXZ - view.rotationAngleXZMin) / (view.rotationAngleXZMax - view.rotationAngleXZMin)
       }
    
}
