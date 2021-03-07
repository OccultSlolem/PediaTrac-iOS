//
//  AppointmentStruct.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/7/21.
//

import Foundation

struct Appointment: Codable, Hashable {
    var date: Date
    var vaccines: [String]
}
