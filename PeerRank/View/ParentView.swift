//
//  ParentView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import SwiftUI

struct ParentView: View {
    var localFileManager = LocalFileManager()
    var coreDataHandler = CoreDataHandler()
    var body: some View {
        TabView {
            NavigationStack {
                HomeView(coreDataHandler: coreDataHandler)
            }
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            NavigationStack {
                PeerListView(
                    localFileManager: localFileManager,
                    coreDataHandler: coreDataHandler
                )
            }
            .tabItem {
                Label("Peers", systemImage: "person")
            }
            ContentView(coreDataHandler: coreDataHandler)
                .tabItem {
                    Label("Admin", systemImage: "person")
                }
        }
    }
}

#Preview {
    ParentView()
}
