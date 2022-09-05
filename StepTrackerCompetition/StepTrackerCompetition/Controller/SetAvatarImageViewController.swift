//
//  SetAvatarImageViewController.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/20/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SetAvatarImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var avatarImage: UIImage = UIImage(named: "DefaultAvatar")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureImageView()
    }
    
    func configureImageView() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.masksToBounds = true
    }
    
    @IBAction func setAvatarImageButtonPressed(_ sender: Any) {
        uploadImageToFirebase()
    }
    
    func uploadImageToFirebase() {
        let userName: String = Auth.auth().currentUser?.email!.components(separatedBy: "@")[0].replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil) ?? "NO USER EMAIL"
        
        let storageRef = Storage.storage().reference().child(userName + "userImage.png")
        
        if let uploadImage = avatarImage.pngData() {
            SVProgressHUD.show()
            
            storageRef.putData(uploadImage, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("Error Uploading Avatar Image:", error!)
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    if error != nil {
                        print("Error Getting Download URL for Avatar Image:", error!)
                    } else {
                        print("DOWNLOAD URL:", url!)
                        if url != nil {
                            self.sendFirebaseImageURLData(downloadURL: url!.absoluteString)
                            self.performSegue(withIdentifier: "toFitnessPartnerSelection", sender: self)
                        }
                    }
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    let stepsDB = Database.database().reference().child("steps")
    
    func sendFirebaseImageURLData(downloadURL: String) {
        
        let imageURLDictionary: [String: Any] = ["profileImageURL": downloadURL]
        
        let userName: String = Auth.auth().currentUser?.email!.components(separatedBy: "@")[0].replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil) ?? "NO USER EMAIL"
        
        self.stepsDB.child(userName).updateChildValues(imageURLDictionary) {
            (error, reference) in
            if error != nil {
                print("Error saveing steps to firebase", error!)
            } else {
                print("Image URL Saved Sucessfully")
            }
        }
    }
    
    @IBAction func changeImageButtonPressed(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        self.dismiss(animated: true, completion: { () -> Void in
            
        })
        
        avatarImage = image
        avatarImageView.image = image
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage
        
        if let possibleImage = info[.editedImage] as? UIImage {
            newImage = possibleImage
        } else if let possibleImage = info[.originalImage] as? UIImage {
            newImage = possibleImage
        } else {
            return
        }
        
        avatarImage = newImage
        avatarImageView.image = newImage
        configureImageView()
        
        dismiss(animated: true)
    }
}
