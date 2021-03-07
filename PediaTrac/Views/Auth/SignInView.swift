//
//  SignInView.swift
//  InfluPeach
//
//  Created by Ethan Hanlon on 2/20/21.
//

import SwiftUI
import FirebaseAuth
import NavigationStack

struct SignInView: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    
    @State private var email = ""
    @State private var password = ""
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
            
            //Title
            HStack {
                Text("Sign in")
                    .font(.largeTitle)
                    .padding(.leading)
                
                Spacer()
            }
            
            
            //Back button
            HStack {
                Button(action: {
                    self.navigationStack.pop()
                }, label: {
                    Group {
                        Image(systemName: "chevron.left.circle.fill")
                            .padding(.leading)
                        Text("Back")
                    }
                    .padding(.top, 1.0)
                    
                })
                
                Spacer()
            }
            
            Spacer()
            
            // Email text field
            CustomStyledTextField(text: $email, placeholder: "Email", symbolName: "envelope", isSecure: false)
                .padding(.bottom)
            
            // Passsword text field
            CustomStyledTextField(text: $password, placeholder: "Password", symbolName: "lock", isSecure: true)
                .padding(.bottom)
            
            //Sign in button
            Button(action: {
                navigationStack.push(ResetPasswordView())
            }, label: {
                HStack {
                    Text("Forgot?")
                    Image(systemName: "chevron.right")
                }
            })
            .padding(.bottom)
            
            CustomStyledTextButton(title: "Sign in", action: {
                emailPasswordSignIn()
            })
            
            Spacer()
        }
    }
    
    //MARK: - Sign in user
    func emailPasswordSignIn() {
        //Make sure user didn't leave any field empty
        if email == "" || password == "" {
            alertTitle = "Sign in failed"
            alertMsg = "Please enter an email and password"
            showingAlert = true
        } else {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if(error == nil) {
                    //Login successful, push to ProfileView
                    self.navigationStack.push(ProfileView())
                } else {
                    //Login failed, present error
                    print("Error signing in with email: \(String(describing: error))")
                    showingAlert = true
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
