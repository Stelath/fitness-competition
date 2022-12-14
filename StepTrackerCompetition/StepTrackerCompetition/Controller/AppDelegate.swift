//
//  AppDelegate.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 12/27/18.
//  Copyright © 2018 AlexanderKorte. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import HealthKit
import OAuthSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance()?.delegate = self
        
        if !UserDefaults.standard.bool(forKey: "didSee") {
            UserDefaults.standard.set(true, forKey: "didSee")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tutorialCollectionViewController = storyboard.instantiateViewController(withIdentifier: "TutorialCollectionViewController")
            
            self.window?.rootViewController = tutorialCollectionViewController
            self.window?.makeKeyAndVisible()
            
            print("Did see true")
        } else {
            
            let healthKitDelegate = HealthKitDelegate()
            
            var alreadySignedIn = false
            
            if Auth.auth().currentUser != nil {
                alreadySignedIn = true
            } else {
                alreadySignedIn = false
            }
            
            healthKitDelegate.requestHealthKitDataAuthorization()
            
            print("Already Signed In:", alreadySignedIn)
            
            let firebaseDelegate = FirebaseDelegate()
            
            if alreadySignedIn {
                firebaseDelegate.sendFirebaseStepData()
            }
            
        }
        
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if error != nil {
            print("Fail'd To log into Google:", error)
            
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Faild to create firebase google account:", error)
                return
            }
            // User is signed in
            // ...
        }
    }
    
    private func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

