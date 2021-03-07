//
//  AddChildView.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/6/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import NavigationStack

struct AddChildView: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    @State private var selectedNumber = 1
    @State private var name = ""
    @State private var presentingToast = false
    @State private var birthDay = Date(timeIntervalSinceNow: 0)
    
    // Represents the range of acceptable dates that a user can pick for their child's birthday
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let startComponents = DateComponents(year: 2016, month: 3, day: 8)
        let endComponents = DateComponents(year: 2021, month: 3, day: 7)
        return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
    }()
    
    var body: some View {
        VStack {
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
            .padding([.top, .leading])
            
            // This form is necessary for the Picker to format correctly
            Form {
                Section {
                    Text("Add Child")
                        .font(.largeTitle)
                    Text("We just need to know how old they are")
                    Text("You can also provide their name to help keep track of them, if you like")
                }
                
                Section {
                    CustomStyledTextField(text: $name, placeholder: "Name (Optional)", symbolName: "person", isSecure: false)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Text("Birthday")
                        Spacer()
                    }
                    DatePicker("", selection: $birthDay, in: dateRange, displayedComponents: [.date])
                        .datePickerStyle(WheelDatePickerStyle())
                }
            }
            
            // MARK: - Upload data
            CustomStyledTextButton(title: "Confirm", action: {
                let db = Firestore.firestore()
                let uid = Auth.auth().currentUser?.uid
                var postName = name
                
                // If a name wasn't specified, set it to "x month old"
                if name == "" {
                    let calendar = Calendar.current
                    let now = Date()
                    let ageComponents = calendar.dateComponents([.month], from: birthDay, to: now)
                    postName = "\(ageComponents.month ?? 1) month old"
                }
                
                // Generate document ID and reference
                let childDoc = db.collection("/users").document(uid!).collection("children").document()
                
                // Set data at document reference point
                childDoc.setData([
                    "name": postName,
                    "birthday": Timestamp(date: birthDay)
                ])
                
                navigationStack.pop()
            })
            .padding(.bottom)
        }
    }
}

struct AddChildView_Previews: PreviewProvider {
    static var previews: some View {
        AddChildView()
    }
}
