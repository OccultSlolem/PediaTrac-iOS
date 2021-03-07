//
//  ChildData.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/6/21.
//

import Foundation

@available(iOS 13.0, *)
final class childData: ObservableObject {
    @Published var children = [Child]()
    
    //TODO: Get ChildData from Firestore
}
