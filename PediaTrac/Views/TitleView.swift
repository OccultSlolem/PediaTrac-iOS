//
//  TitleView.swift
//  InfluPeach
//
//  Created by Ethan Hanlon on 2/20/21.
//

import SwiftUI
import NavigationStack
import FirebaseAuth

struct TitleView: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    
    var body: some View {
        VStack {
            //Alert handler
            Button(action: {
                    print("Alert")

            }, label: {
                Text("")
            })
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
            })
            .hidden()
            
            Text("PediaTrac")
                .font(.largeTitle)
            
            Text("Keep track of your young child's appointments")
            
            Spacer()
            
            //Login button
            CustomStyledTextButton(title: "Login", action: {
                navigationStack.push(SignInView())
            })
            
            //Register button
            CustomStyledTextButton(title: "Sign up", action: {
                navigationStack.push(SignUpView())
            })
            .padding(.bottom)
            
            Divider()
            
            Text("Or")
            CustomStyledTextButton(title: "Sign in Anonymously", action: {
                Auth.auth().signInAnonymously { authResult, error in
                    if let error = error {
                        alertTitle = "Something went wrong"
                        alertMsg = error.localizedDescription
                        showingAlert = true
                    } else {
                        navigationStack.push(ProfileView())
                    }
                }
            })
        }
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
