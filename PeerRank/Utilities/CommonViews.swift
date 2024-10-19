//
//  CommonViews.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import Foundation
import SwiftUI

class CommonViews {
    @ViewBuilder
    static func textField(bindingText: Binding<String>, placeholderText: String) -> some View{
        TextField("Label", text: bindingText, prompt: Text(placeholderText))
            .textContentType(.username)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color.gray.opacity(0.1))
            )
    }
    static func textEditor(bindingText: Binding<String>) -> some View {
        TextEditor(text: bindingText)
            
            .autocorrectionDisabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
            .foregroundColor(.primary)
            .multilineTextAlignment(.leading)
            .lineLimit(5)
            .lineSpacing(1.0)
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.secondary, lineWidth: 1)
            )
            .frame(height: 100)
    }
    static func buttonLabel(buttonText: String = "Save") -> some View {
        Text(buttonText)
            .tint(.white)
            .fontWeight(.bold)
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                Color.accentColor
            )
            .cornerRadius(10)
    }
}
