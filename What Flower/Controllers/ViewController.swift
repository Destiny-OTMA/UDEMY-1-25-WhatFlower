//
//  ViewController.swift
//  What Flower
//
//  Created by Destiny Sopha on 8/29/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  let imagePicker = UIImagePickerController()
  
  @IBOutlet weak var imageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.sourceType = .camera

  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    let userPickedImage = info[UIImagePickerController.InfoKey.editedImage]
    
    imageView.image = userPickedImage as? UIImage
    
    imagePicker.dismiss(animated: true, completion: nil)
    
  }
  
  @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
    
    present(imagePicker, animated: true, completion: nil)
    
  }
  
  
} // This is the end of the ViewController Class Statement

