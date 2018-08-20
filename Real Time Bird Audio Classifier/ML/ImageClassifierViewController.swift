//
//  ImageClassifierViewController.swift
//  Real Time Bird Audio Classifier
//
//  Created by Kavilan Nair on 2018/08/07.
//  Copyright © 2018 Lab Proj. All rights reserved.
//

import UIKit
import Vision
import CoreML


class ImageClassifierViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var importImageButton: NSLayoutConstraint!
//    @IBOutlet weak var identifierLabel: UILabel!
    @IBOutlet weak var classifierLabel: UILabel!
    @IBOutlet weak var Accuracy: UILabel!
    
    
    
    var model: it_5!
    
    override func viewWillAppear(_ animated: Bool) {
        model = it_5()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func importImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary
        image.allowsEditing = false
        
        self.present(image, animated: true){
//            after it is complete
        }
        
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        myImageView.image = image
    

        self.dismiss(animated: true, completion: nil)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 200, height: 100), true, 2.0)
        image.draw(in: CGRect(x: 0, y: 0, width: 200, height: 100))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue) //3
        
        context?.translateBy(x: 0, y: newImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        myImageView.image = newImage
        
        guard let prediction = try? model.prediction(image: pixelBuffer!) else {
            return
        }
        
        
        let bestGuess = prediction.classLabel
        let accVal = prediction.output1[prediction.classLabel]!
        let rounded = Double(round(1000*accVal)/1000)*100
        classifierLabel.text = "\(bestGuess)"
        Accuracy.text = "\(String(describing: rounded))" + "%"
        
//        + "\(String(describing: prediction.output1[prediction.classLabel]))"
//        print("Here")
//        print( !prediction.output1[prediction.classLabel])
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
