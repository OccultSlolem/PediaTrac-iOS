//
//  CustomStyledTextField.swift
//  InfluPeach
//
//  Created by Ethan Hanlon on 2/20/21.
//

import SwiftUI

struct CustomStyledTextField: View {
    @Binding var text: String
    let placeholder: String
    let symbolName: String
    let isSecure: Bool
    
    var body: some View {
        HStack {
            Image(systemName: symbolName)
                .padding(.leading)
            
            if !isSecure {
                TextField(placeholder, text: $text)
                    .padding(.vertical)
                    .accentColor(.orange)
                    .autocapitalization(.none)
            } else {
                SecureField(placeholder, text: $text)
                    .padding(.vertical)
                    .accentColor(.orange)
                    .autocapitalization(.none)
            }
        }
        .background(
            RoundedRectangle(cornerSize: CGSize(width: 16, height: 16), style: .circular)
                .foregroundColor(Color(.secondarySystemFill))
        )
        .padding(.horizontal)
    }
}

struct CustomStyledTextField_Previews: PreviewProvider {
    @State static var txt = String()
    static var previews: some View {
        CustomStyledTextField(text: $txt, placeholder: "Email", symbolName: "person.crop.circle.fill", isSecure: false)
    }
}
