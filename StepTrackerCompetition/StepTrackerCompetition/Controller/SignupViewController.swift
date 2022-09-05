//
//  SignInViewController.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/6/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import UIKit
import GoogleSignIn

class SignupViewController: UIViewController, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
    }

    @IBAction func googleSignupButtonPressed(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
        performSegue(withIdentifier: "fromSignupToChooseAvatar", sender: self)
    }
    
}
