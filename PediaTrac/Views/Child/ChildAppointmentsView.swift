//
//  ChildAppointmentsView.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/6/21.
//

import SwiftUI
import FirebaseFirestoreSwift
import NavigationStack
import EventKit
import EventKitUI


struct ChildAppointmentsView: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    var child: Child
    
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
            
            Text("Appointments")
                .font(.largeTitle)
            Text("Based on your child's age, we recommend they see a pediatrician at these dates:")
                .multilineTextAlignment(.leading)
            Divider()
            
            ScrollView {
                ForEach(child.appointments, id: \.self) { appointment in
                    HStack {
                        Text("• " + formatDate(date: appointment.date))
                            .font(.headline)
                        
                        Spacer()
                        
                        Button(action: {
                            addToCalendar(date: appointment.date)
                        }, label: {
                            Text("Save to calendar")
                            Image(systemName: "calendar.badge.plus")
                        })
                        
                        Spacer()
                        
                        Button(action: {
                            alertTitle = "Vaccines"
                            alertMsg = getVaccineList(vaccines: appointment.vaccines)
                            showingAlert = true
                        }, label: {
                            Text("Vaccines")
                            Image(systemName: "chevron.right")
                        })
                    }
                    .padding()
                }
            }
        }
    }
    
    // MARK: - Format vaccine list
    func getVaccineList(vaccines: [String]) -> String {
        var returnValue = ""
        for vaccine in vaccines {
            returnValue = returnValue + "\n• \(vaccine)"
        }
        
        return returnValue
    }
    
    // MARK: Format date
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdy")
        
        return dateFormatter.string(from: date)
    }
    
    // MARK: - Add to calendar
    func addToCalendar(date: Date) {
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted,error in
            if granted && error == nil {
                print("granted \(granted)")
                print("error \(String(describing: error))")
                
                let event:EKEvent = EKEvent(eventStore: eventStore)
                
                event.title = child.name + " pediatric appointment"
                event.startDate = date
                event.endDate = date
                event.notes = "Time for " + child.name + "'s appointment!"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("failed to save event with error: \(error)")
                }
                
                alertTitle = "Saved"
                alertMsg = "This event has been saved to your calendar"
                showingAlert = true
            } else {
                print("failed to save event with error: \(String(describing: error)) or access not granted")
            }
        }
    }
}

struct ChildAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        ChildAppointmentsView(child: Child(id: "123", name: "This dood", appointments: [Appointment(date: Date(timeIntervalSince1970: 1615098141), vaccines: ["MMR"])]))
    }
}
