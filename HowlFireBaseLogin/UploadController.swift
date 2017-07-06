//
//  UploadController.swift
//  HowlFireBaseLogin
//
//  Created by 유명식 on 2017. 6. 23..
//  Copyright © 2017년 swift. All rights reserved.
//

import UIKit
import Firebase

class UploadController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var subject: UITextField!
    @IBOutlet weak var explaination: UITextField!
    @IBAction func uploadButton(_ sender: Any) {
    upload()
    
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openGallery)))
        imageView.isUserInteractionEnabled = true
        // Do any additional setup after loading the view.
    }
    
     func openGallery() {
        
        let imagePick = UIImagePickerController()
        imagePick.delegate = self
        imagePick.allowsEditing = true
        imagePick.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(imagePick, animated: true, completion: nil)
        
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        
        
    }
    func upload(){
        
        let image = UIImageJPEGRepresentation(self.imageView.image!,0.1)
        
        let imageName = FIRAuth.auth()!.currentUser!.uid + "\(Int(NSDate.timeIntervalSinceReferenceDate * 1000)).jpg"
        
        let riversRef = FIRStorage.storage().reference().child("ios_images").child(imageName)
        
        riversRef.put(image!, metadata: nil) { metadata, error in
            if (error != nil) {
                // Uh-oh, an error occurred!
            } else {
                // Metadata contains file metadata such as size, content-type, and download URL.
                if let downloadURL = metadata!.downloadURL()?.absoluteString{
                FIRDatabase.database().reference().child("users").childByAutoId().setValue([
                    "userId": FIRAuth.auth()?.currentUser?.email,
                    "uid": FIRAuth.auth()?.currentUser?.uid,
                    "subject": self.subject.text!,
                    "explaination": self.explaination.text!,
                    "imageUrl": downloadURL,
                    "imageName":imageName
                    
                    ])
                self.dismiss(animated: true, completion: nil)
                }
                
                
                
            }
        }
        

        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
