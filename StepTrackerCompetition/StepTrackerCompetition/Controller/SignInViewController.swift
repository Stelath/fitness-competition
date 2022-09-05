//
//  SignInViewController.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/20/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import GoogleSignIn

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passwordTextFeild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        Auth.auth().signIn(withEmail: emailTextFeild.text!, password: passwordTextFeild.text!) {
            (user, error) in
            if error != nil {
                print(error!)
            } else {
                SVProgressHUD.dismiss()
                print("Login Sucessfull")
                self.performSegue(withIdentifier: "fromLogInToInitialViewController", sender: self)
            }
        }
    }
    
    @IBAction func googleSignupButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        performSegue(withIdentifier: "fromLogInToInitialViewController", sender: self)
    }
    
}
