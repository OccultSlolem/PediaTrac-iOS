//
//  ContentView.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/6/21.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    var body: some View {
        if Auth.auth().currentUser != nil {
            // User is signed in
            ProfileView()
        } else {
            // No user is signed in
            TitleView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
