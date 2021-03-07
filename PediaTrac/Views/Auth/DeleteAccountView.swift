//
//  DeleteAccountView.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/7/21.
//

import SwiftUI
import FirebaseAuth
import NavigationStack

struct DeleteAccountView: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    @State private var password = ""
    @State private var showingDeletionAlert = false
    
    // Alert box
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    
    var body: some View {
        VStack {
            // Alert handler
            Button(action: {
                print("Alert")
            }, label: {
                Text("")
            })
            .alert(isPresented: $showingAlert, content: {
                Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
            })
            .hidden()
            
            // Back button
            HStack {
                Button(action: {
                    navigationStack.pop()
                }, label: {
                    Image(systemName: "chevron.left.circle.fill")
                    Text("Back")
                })
                
                Spacer()
            }
            .padding(.leading)
            
            Spacer()
            
            Text("Delete account")
                .font(.largeTitle)
            Text("Please reenter your password to continue")
                .padding(/*@START_MENU_TOKEN@*/.bottom/*@END_MENU_TOKEN@*/)
            
            CustomStyledTextField(text: $password, placeholder: "Password", symbolName: "lock", isSecure: true)
                .padding(.bottom)
            
            CustomStyledTextButton(title: "Delete Account", action: {
                if password == "" {
                    // No password was entered
                    alertTitle = "Failed"
                    alertMsg = "Please enter your password"
                    showingAlert = true
                } else {
                    showingDeletionAlert = true
                }
            })
            .alert(isPresented: $showingDeletionAlert, content: {
                Alert(title: Text("We're sorry to see you go!"),
                      message: Text("Any information you gave to us will be immediately deleted. This action is not reversible."),
                      primaryButton: .destructive(Text("Delete"), action: {
                        let currentUser = Auth.auth().currentUser
                        
                        // Firebase requires reauthentication before destructive actions
                        currentUser?.reauthenticate(with: EmailAuthProvider.credential(withEmail: (currentUser?.email)!, password: password)) { authResult, error in
                            if let error = error {
                                // Something went wrong
                                alertTitle = "Failed"
                                alertMsg = error.localizedDescription
                                showingAlert = true
                            } else {
                                // Now try to delete the account
                                currentUser?.delete() { error in
                                    if let error = error {
                                        alertTitle = "Failed"
                                        alertMsg = error.localizedDescription
                                        showingAlert = true
                                    } else {
                                        do {
                                            try Auth.auth().signOut()
                                        } catch {
                                            print("Error signing out: \(error)")
                                        }
                                        navigationStack.push(TitleView())
                                    }
                                }
                            }
                        }
                        
                      }),
                      secondaryButton: .cancel()
                )
            })
            
            Spacer()
        }
    }
}

struct DeleteAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView()
    }
}
