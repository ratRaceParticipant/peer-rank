//
//  Toggleview.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 05/10/24.
//

import SwiftUI

struct Toggleview: View {
    var label: String
    @Binding var isToggleOn: Bool
    
    var body: some View {
        Toggle(label, isOn: $isToggleOn)
    }
}

#Preview {
    Toggleview(
        label: "Label",
        isToggleOn: .constant(true)
    )
}
