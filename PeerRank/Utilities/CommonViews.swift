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
}
