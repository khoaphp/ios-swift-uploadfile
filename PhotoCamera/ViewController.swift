//
//  ViewController.swift
//  PhotoCamera
//
//  Created by Khoa Phạm on 07/10/2023.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imgvPhoto: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func choosePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage {
            imgvPhoto.image = image
        }else{
            // file chosen is not image extension
        }
        self.dismiss(animated: true)
    }
    
    @IBAction func uploadPhoto(_ sender: Any) {
        let urlUploadFile = URL(string: "http://localhost:3000/uploadFile")
        let boundary = UUID().uuidString
        var urlRequest  = URLRequest(url: urlUploadFile!)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var imageData = Data()
        imageData.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        imageData.append("Content-Disposition:form-data; name=\"avatar\"; filename=\"filefromdevice.png\"\r\n".data(using: .utf8)!)
        imageData.append("Content-Type:image/png\r\n\r\n".data(using: .utf8)!)
        imageData.append(imgvPhoto.image!.pngData()!)
        imageData.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        URLSession.shared.uploadTask(with: urlRequest, from: imageData) { responseData, responseCode, error in
            if error==nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let jsonObject = jsonData as? [String:Any]{
                    print(jsonObject)
                }
            }
        }.resume()
        
    }
    
    
}

