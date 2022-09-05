//
//  HealthDataProviderViewController.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/15/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import UIKit
import SVProgressHUD

class HealthDataProviderViewController: UIViewController {
    
    let healthKitDelegate = HealthKitDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func appleHealthButtonPressed(_ sender: Any) {
        SVProgressHUD.show()
        
        if healthKitDelegate.requestHealthKitDataAuthorization() != [] {
            SVProgressHUD.dismiss()
            performSegue(withIdentifier: "fromChooseHealthDataProviderToInitialViewController", sender: nil)
        } else {
            SVProgressHUD.dismiss()
            
            let alert = UIAlertController(title: "Coulden't Get Health Data", message: "Please make sure to enable health data for this app in settings", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
