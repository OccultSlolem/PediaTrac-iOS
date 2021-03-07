//
//  CustomStyledTextButton.swift
//  InfluPeach
//
//  Created by Ethan Hanlon on 2/20/21.
//

import SwiftUI

struct CustomStyledTextButton: View {
    private var osTheme: UIUserInterfaceStyle {
        return UIScreen.main.traitCollection.userInterfaceStyle
    }
    
    var title: String
    var action: () -> Void
    var backgroundColor: Color? {
        if osTheme == UIUserInterfaceStyle.dark {
            return .white
        } else {
            return .black
        }
    }
    var textColor: Color? {
        if osTheme == UIUserInterfaceStyle.dark {
            return .black
        } else {
            return .white
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                Text(LocalizedStringKey(title))
                    .padding()
                    .accentColor(.white)
                    .font(.title2)
                    .foregroundColor(textColor)
                Spacer()
            }
        }
        .background(backgroundColor)
        .cornerRadius(16)
        .padding(.horizontal)
    }
}

struct CustomStyledTextButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomStyledTextButton(title: "String", action: {
            print(":)")
        })
    }
}
