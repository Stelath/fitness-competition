//
//  HealthKitProfileDataStore.swift
//  StepTrackerCompetition
//
//  Created by Alexander Korte on 12/27/18.
//  Copyright © 2018 AlexanderKorte. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitDelegate {
    
    func requestHealthKitDataAuthorization() -> Set<HKSampleType> {
        if HKHealthStore.isHealthDataAvailable() {
            let healthStore = HKHealthStore()
            
            let allDataTypes: Set<HKSampleType> = [HKObjectType.quantityType(forIdentifier: .stepCount)!]
            
            healthStore.requestAuthorization(toShare: allDataTypes, read: allDataTypes) { (success, error) in
                if !success {
                    print("Rejected Authorization")
                } else {
                    print("Got Health Kit Data")
                }
            }
            return allDataTypes
        }
        return []
    }
    
    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let healthStore = HKHealthStore()
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(0.0)
                return
            }
            completion(sum.doubleValue(for: HKUnit.count()))
        }
        
        healthStore.execute(query)

    }
}
