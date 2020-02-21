//
//  GalleryViewController.swift
//  Food_FYPJ
//
//  Created by Agnes on 11/2/20.
//  Copyright © 2020 Agnes. All rights reserved.
//

import Foundation
import UIKit

func getImage(imageName: String){
   let fileManager = FileManager.default
   let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
   if fileManager.fileExists(atPath: imagePath){
      imageView.image = UIImage(contentsOfFile: imagePath)
   }else{
      print("Panic! No Image!")
   }
}
