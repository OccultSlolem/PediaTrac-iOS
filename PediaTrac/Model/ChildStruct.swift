//
//  ChildStruct.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/6/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Child: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var appointments: [Appointment]
}
