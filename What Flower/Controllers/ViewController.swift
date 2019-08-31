//
//  ViewController.swift
//  What Flower
//
//  Created by Destiny Sopha on 8/29/2019.
//  Copyright © 2019 Destiny Sopha. All rights reserved.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  let wikipediaURL = "https://en.wikipedia.org/w/api.php"
  let imagePicker = UIImagePickerController()
  
  @IBOutlet weak var label: UILabel!
  @IBOutlet weak var imageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    imagePicker.delegate = self
    imagePicker.allowsEditing = true
    imagePicker.sourceType = .camera
    
  }
  
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

    if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {  // Let user pick an image

      guard let convertedCIImage = CIImage(image: userPickedImage) else { // convert their image to a CIImage
        fatalError("cannot convert to CIImage")
      }

      detect (image: convertedCIImage) // and pass the converted image into the method called detect

      imageView.image = userPickedImage

    }

    imagePicker.dismiss(animated: true, completion: nil)
  }

  
  func detect(image: CIImage) {
    
    guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
      
      fatalError("cannot import model")
      
    }
    
    let request = VNCoreMLRequest(model: model) { (request, error) in
      guard let classification = request.results?.first as? VNClassificationObservation else {
        fatalError("Could not classify image.")
      }
      
      self.navigationItem.title = classification.identifier.capitalized
      self.requestWikiInfo(flowerName: classification.identifier)

    }
  
  let handler = VNImageRequestHandler(ciImage: image)
  
  do {
  try handler.perform([request])
  }
  
  catch {
    print(error)
  }
  
  }
  
  func requestWikiInfo(flowerName: String) {
    
    let parameters : [String:String] = [
      "format" : "json",
      "action" : "query",
      "prop" : "extracts",
      "exintro" : "",
      "explaintext" : "",
      "titles" : flowerName,
      "indexpageids" : "",
      "redirects" : "1",
    ]
    
    Alamofire.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { (response) in
      if response.result.isSuccess {
        print("Got the Wikipedia information.")
        print(response)
        
        let flowerJSON : JSON = JSON(response.result.value!)
        
        let pageID = flowerJSON["query"]["pageids"][0].stringValue
        
        let flowerDescription = flowerJSON["query"]["pages"][pageID]["extract"].stringValue
        
        self.label.text = flowerDescription
        
      }
    }
  }
  
  @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
    present(imagePicker, animated: true, completion: nil)
    
  }

} // This is the end of the ViewController Class Statement

