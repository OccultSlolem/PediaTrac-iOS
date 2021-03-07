//
//  ChildData.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

// Number of seconds since birth that a child should be brought to pediatrician
let visitDurations = [
    //60 seconds * 60 minutes * 24 hrs * 4 days
    ((60*60*24) * 4), // 4 days
    ((60*60*24) * 30), // 30 days
    ((60*60*24) * 60),
    ((60*60*24) * 120),
    ((60*60*24) * 180),
    //1 year
    (31556952),
    Int(31556952 * 1.3),
    Int(31556952 * 1.5),
    //2 year
    (31556952 * 2),
    Int(31556952 * 2.5),
    (31556952 * 3),
    (31556952 * 4),
    (31556952 * 5)
] as [Int]

@available(iOS 13.0, *)
final class ChildData: ObservableObject {
    @Published var children = [Child]()
    
    /*
     The first week visit (3 to 5 days old)
     1 month old [0]
     2 months old [1]
     4 months old [2]
     6 months old [3]
     9 months old [4]
     12 months old [5]
     15 months old [6]
     18 months old [7]
     2 years old (24 months) [8]
     2 ½ years old (30 months) [9]
     3 years old [10]
     4 years old [11]
     5 years old [12]
     
     For each visit duration:
     1.) Check if unix timestamp at birthday + timeinterval >= current unix timestamp
     2.) If true, get that amount of time past birthday
     3.) Add date to appointments array
     
     */
    func getChildData() {
        let db = Firestore.firestore()
        db.collection("users/" + (Auth.auth().currentUser?.uid ?? "") + "/children").addSnapshotListener { collectionSnapshot, error in
            guard let collection = collectionSnapshot else {
                print("Failed to get child data: \(String(describing: error))")
                return
            }
            
            self.children = collection.documents.map { document -> Child in
                let data = document.data()
                
                let birthday = data["birthday"] as? Timestamp ?? Timestamp(date: Date())
                var appointments = [Date]()
                
                // Calculate appointments based on child age
                for visit in visitDurations {
                    let birthdayEpochDate = birthday.dateValue().timeIntervalSince1970
                    let time = Date().timeIntervalSince1970
                    if birthdayEpochDate + Double(visit) >= time {
                        //Appointment time is in future, add to appointments array
                        appointments.append(Date(timeIntervalSince1970: birthdayEpochDate + Double(visit)))
                    }
                }
                
                return Child(id: document.documentID, name: data["name"] as! String, appointments: appointments)
            }
        }
    }
    
    
}
