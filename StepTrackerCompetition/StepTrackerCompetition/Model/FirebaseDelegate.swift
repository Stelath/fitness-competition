//
//  FirebaseDelegate.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/19/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import Foundation
import Firebase

class FirebaseDelegate {
    
    let stepsDB = Database.database().reference().child("steps")
    
    func sendFirebaseStepData() {
        let healthKitDelegate = HealthKitDelegate()
        
        healthKitDelegate.getTodaysSteps(completion: {
            (result) -> Void in
            
            let date = Date()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd.MM.yyyy"
            
            let stepCount = String(Int(result))
            let stepsDictionary: [String: Any] = ["user": Auth.auth().currentUser?.email!.components(separatedBy: "@")[0] ?? "NO USER EMAIL", "stepCount": stepCount, "date": formatter.string(from: date)]
            
            print("STEP COUNT:", stepCount)
            print("STEP DICTIONARY:", stepsDictionary)
            
            let userName: String = Auth.auth().currentUser?.email!.components(separatedBy: "@")[0].replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil) ?? "NO USER EMAIL"
            
            print("User Name:", userName)
            
            self.stepsDB.child(userName).updateChildValues(stepsDictionary) {
                (error, reference) in
                if error != nil {
                    print("Error saveing steps to firebase", error!)
                } else {
                    print("Steps Saved Sucessfully")
                }
            }
        })
    }
}
