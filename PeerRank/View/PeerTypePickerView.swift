//
//  PeerTypePickerView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI

struct PeerTypePickerView: View {
    @Binding var pickerTypeId: Int16
    var body: some View {
        
        VStack {
            Picker(selection: $pickerTypeId) {
                ForEach(PeerType.allCases,id: \.rawValue) { item in
                    Text(item.getPeerTypeString())
                }
            } label: {
                Text("PICKER")
            }
            .pickerStyle(.menu)

        }
    }
}

#Preview {
    PeerTypePickerView(pickerTypeId: .constant(4))
}
