//
//  SignUpWithMailViewController.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/13/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class SignUpWithMailViewController: UIViewController {
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SignUpButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        Auth.auth().createUser(withEmail: emailTextFeild.text!, password: passwordTextFeild.text!) {
            (user, error) in
            if error != nil {
                print(error!)
            } else {
                SVProgressHUD.dismiss()
                print("Regestration Sucessfull")
                self.performSegue(withIdentifier: "fromEmailSignupToChooseAvatar", sender: nil)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        SVProgressHUD.dismiss()
        dismiss(animated: true, completion: nil)
    }
    
}
