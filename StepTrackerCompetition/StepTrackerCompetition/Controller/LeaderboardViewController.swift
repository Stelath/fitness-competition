//
//  LeaderboardViewController.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 1/16/19.
//  Copyright © 2019 Alexander Korte. All rights reserved.
//

import UIKit
import Firebase

class LeaderboardViewController: UITableViewController {
    
    @IBOutlet var leaderboardTableView: UITableView!
    
    var stepData: [StepDataModel] = [StepDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leaderboardTableView.delegate = self
        leaderboardTableView.dataSource = self
        
        leaderboardTableView.register(UINib(nibName: "TopFitnessLeaderboardCell", bundle: nil), forCellReuseIdentifier: "topCell")
        leaderboardTableView.register(UINib(nibName: "FitnessLeaderboardCell", bundle: nil), forCellReuseIdentifier: "normalCell")
        
        configureTableView()
        retrieveStepData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stepData.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "topCell", for: indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath) as! FitnessLeaderboardCell
            
            cell.user.text = stepData[indexPath.row - 1].user
            cell.stepCount.text = stepData[indexPath.row - 1].stepCount
            cell.userImage.image = stepData[indexPath.row - 1].profileImage
            
            return cell
        }
        
    }
    
    func retrieveStepData() {
        let stepsDB = Database.database().reference().child("steps")
        
        stepsDB.observe(.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            
            let dateFromDatabase = snapshotValue["date"]!
            let user = snapshotValue["user"]!
            let stepCount = snapshotValue["stepCount"]!
            
            let stepDataModel = StepDataModel()
            stepDataModel.user = user
            stepDataModel.stepCount = stepCount
            
            if let imageURL = snapshotValue["profileImageURL"] {
                let url = NSURL(string: imageURL)
                let request = URLRequest(url: url! as URL)
                URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (imageData, response, error) in
                    if error != nil {
                        print("Error Getting Image:", error!)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        stepDataModel.profileImage = UIImage(data: imageData!)!
                    }
                }).resume()
            }
            
            let date = Date()
            let formatter = DateFormatter()
            
            formatter.dateFormat = "dd.MM.yyyy"
            
            if dateFromDatabase == formatter.string(from: date) {
                self.stepData.append(stepDataModel)
                self.stepData = self.stepData.sorted {
                    $0.stepCount > $1.stepCount
                }
                print("STEP DATA:", self.stepData)
            }
            
            self.configureTableView()
            self.leaderboardTableView.reloadData()
        }
    }
    
    func configureTableView() {
        leaderboardTableView.rowHeight = UITableView.automaticDimension
        leaderboardTableView.estimatedRowHeight = 180
        leaderboardTableView.separatorStyle = .none
    }
}
