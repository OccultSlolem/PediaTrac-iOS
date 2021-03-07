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

// Number of seconds since birth that a child should be brought to pediatrician, and the corresponding vaccines they should receive
// Vaccines source: https://redbook.solutions.aap.org/selfserve/ssPage.aspx?SelfServeContentId=Immunization_Schedules
let visitDurations = [
    // 60 seconds * 60 minutes * 24 hrs * 4 days
    ((60*60*24) * 4): ["HepB 1st dose"], // 4 days HepB 1st dose
    ((60*60*24) * 30): ["HepB 2nd dose"], // 30 days HepB 2nd dose
    ((60*60*24) * 60): ["RV 1st dose", "DTap 1st dose", "Hib 1st dose", "PCV13 1st dose", "IPV 1st dose"],
    ((60*60*24) * 120): ["RV 2nd dose", "DTap 2nd dose", "Hib 2nd dose", "PCV13 2nd dose", "IPV 2nd dose"],
    ((60*60*24) * 180): ["RV 3rd dose", "DTap 3rd dose", "Hib 3rd dose", "PCV13 3rd dose", "IPV 3rd dose"],
    // 1 year
    (31556952): ["MMR 1st dose", "VAR 1st Dose", "HepA 1st dose", "Hib 4th dose", "PCV13 4th dose", "Annual flu vaccine"],
    Int(31556952 * 1.3): ["DTap 4th dose", "HepA 2nd dose"],
    Int(31556952 * 1.5): ["HebB 3rd dose", "IPV 3rd dose"],
    // 2 year
    (31556952 * 2): ["Annual flu vaccine"],
    Int(31556952 * 2.5): [],
    (31556952 * 3): ["Annual flu vaccine"],
    (31556952 * 4): ["Annual flu vaccine", "DTap 5th dose", "IPV 4th dose", "MMR 2nd dose", "VAR 2n dose"],
    (31556952 * 5): ["Annual flu vaccine"]
]

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
                var appointments = [Appointment]()
                
                // Calculate appointments based on child age
                // visit.key: Int: Seconds since birth to bring child to pediatrician
                // visit.value: [String]: Vaccines they should receive at this visit
                for visit in visitDurations {
                    let birthdayEpochDate = birthday.dateValue().timeIntervalSince1970
                    let time = Date().timeIntervalSince1970
                    if birthdayEpochDate + Double(visit.key) >= time {
                        //Appointment time is in future, add to appointments array
                        appointments.append(Appointment(date: Date(timeIntervalSince1970: birthdayEpochDate + Double(visit.key)), vaccines: visit.value))
                    }
                }
                
                return Child(id: document.documentID, name: data["name"] as! String, appointments: appointments)
            }
        }
    }
    
    
}
