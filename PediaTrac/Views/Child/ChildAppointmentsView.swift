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

struct ChildAppointmentsView: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    var child: Child
    
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
            
            Text("Appointments")
                .font(.largeTitle)
            Text("Based on your child's age, we recommend they see a pediatrician at these dates:")
                .multilineTextAlignment(.leading)
            Divider()
            
            ScrollView {
                ForEach(child.appointments, id: \.self) { date in
                    HStack {
                        Text("• " + formatDate(date: date))
                            .font(.headline)
                        Spacer()
                        Button(action: {
                            addToCalendar(date: date)
                        }, label: {
                            Text("Save to calendar")
                            Image(systemName: "calendar.badge.plus")
                        })
                    }
                    .padding()
                }
            }
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdy")
        
        return dateFormatter.string(from: date)
    }
    
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
                print("Saved Event")
            } else {
                print("failed to save event with error: \(String(describing: error)) or access not granted")
            }
        }
    }
}

struct ChildAppointmentsView_Previews: PreviewProvider {
    static var previews: some View {
        ChildAppointmentsView(child: Child(id: "123", name: "This dood", appointments: [Date(timeIntervalSince1970: 1615098141)]))
    }
}
