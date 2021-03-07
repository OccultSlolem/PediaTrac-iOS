//
//  ChildListRow.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/6/21.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import NavigationStack

struct ChildListRow: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    @State private var showingAlert = false
    var child: Child
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            Text(child.name)
            
            Spacer()
            
            Button(action: {
                showingAlert = true
            }, label: {
                Text("Delete")
                    .foregroundColor(.red)
            })
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Are you sure you want to delete " + child.name + "?"), message: Text("You cannot undo this action"),
                    primaryButton: .destructive(Text("Delete")) {
                        let db = Firestore.firestore()
                        
                        db.document(
                            "/users/\(Auth.auth().currentUser?.uid ?? "")/children/\(child.id ?? "")"
                        ).delete()
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
            
            Button(action: {
                navigationStack.push(ChildAppointmentsView(child: child))
            }, label: {
                Text("Appointments")
                Image(systemName: "chevron.right")
            })
        }
        .padding([.leading, .bottom, .trailing])
    }
}

struct ChildListRow_Previews: PreviewProvider {
    static var previews: some View {
        ChildListRow(child: Child(id: "123", name: "JimBob", appointments: [Appointment(date: Date(timeIntervalSince1970: 1615103513), vaccines: ["MMR"])]))
            .previewLayout(.sizeThatFits)
    }
}
