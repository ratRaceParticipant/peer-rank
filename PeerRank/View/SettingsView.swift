//
//  SettingsView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 12/10/24.
//

import SwiftUI

struct SettingsView: View {
    
    
    var body: some View {
        List {
            Section {
                Button {
                    
                } label: {
                    Text("Import Data")
                }
                .tint(.blue)
                Button {
                    
                } label: {
                    Text("Export Data")
                }
                .tint(.blue)
                
            } header: {
                Text("Data Managment")
            } footer: {
                
            }

        }
    }
}

#Preview {
    SettingsView()
}
