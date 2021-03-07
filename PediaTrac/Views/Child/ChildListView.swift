//
//  ChildListView.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/6/21.
//

import SwiftUI
import FirebaseAuth
import NavigationStack

struct ChildListView: View {
    // Grab list of children
    @EnvironmentObject private var childData: ChildData
    @EnvironmentObject private var navigationStack: NavigationStack
    
    // Alert box
    @State private var showingAccountDeletionAlert = false
    @State private var showingAlert = false
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var name = ""
    
    
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
            
            Text("Your Children")
                .font(.largeTitle)
            
            Text("Hello, " + (Auth.auth().currentUser?.email ?? "human") + "!")
            Divider()
            
            if childData.children.indices.isEmpty {
                Spacer()
                Text(":(")
                    .font(.largeTitle)
                Text("You don't seem to have any children added yet.")
                Text("Why don't you add some below?")
                Spacer()
                
            } else {
                ScrollView {
                    ForEach(childData.children) { child in
                        ChildListRow(child: child)
                    }
                    .padding(.top)
                }
            }
            
            HStack {
                CustomStyledTextButton(title: "Log Out", action: {
                    let isAnonymous = Auth.auth().currentUser?.isAnonymous
                    // If user is anonymous, delete account data on signout
                    if isAnonymous ?? false {
                        Auth.auth().currentUser?.delete { error in
                            if let error = error {
                                alertTitle = "Failed to sign out"
                                alertMsg = error.localizedDescription
                                showingAlert = true
                            }
                        }
                    }
                    
                    do {
                        try Auth.auth().signOut()
                        self.navigationStack.push(TitleView())
                    } catch {
                        alertTitle = "Failed to sign out"
                        alertMsg = "Something broke on our end. Try signing out again or restarting."
                        showingAlert = true
                    }
                })
                if !(Auth.auth().currentUser?.isAnonymous ?? true) {
                    CustomStyledTextButton(title: "Delete all", action: {
                        navigationStack.push(DeleteAccountView())
                    })
                }
                
            }
            .padding(.bottom)
            
            CustomStyledTextButton(title: "Add Child") {
                navigationStack.push(AddChildView())
            }
            .padding(.bottom)
            
        }
        .onAppear(perform: {
            self.childData.getChildData()
        })
    }
}

struct ChildListView_Previews: PreviewProvider {
    static var previews: some View {
        ChildListView()
    }
}
