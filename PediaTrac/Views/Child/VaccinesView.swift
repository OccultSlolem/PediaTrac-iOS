//
//  VaccinesView.swift
//  PediaTrac
//
//  Created by Ethan Hanlon on 3/7/21.
//

import SwiftUI
import NavigationStack

struct VaccinesView: View {
    @EnvironmentObject private var navigationStack: NavigationStack
    var appointment: Appointment
    
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
            
            Text("Vaccines")
                .font(.largeTitle)
            Text("At your child's \(formatDate(date: appointment.date)) appointment, we recommend they receive these vaccines")
            
            Spacer()
            
            ForEach(appointment.vaccines, id: \.self) { vaccine in
                Text("• \(vaccine)")
            }
            
            Spacer()
            
        }
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdy")
        
        return dateFormatter.string(from: date)
    }
}

struct VaccinesView_Previews: PreviewProvider {
    static var previews: some View {
        VaccinesView(appointment: Appointment(date: Date(), vaccines: ["MMR"]))
    }
}
