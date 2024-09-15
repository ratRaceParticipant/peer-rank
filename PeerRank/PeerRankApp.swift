//
//  PeerRankApp.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import SwiftUI

@main
struct PeerRankApp: App {
    var localFileManager = LocalFileManager()
    var coreDataHandler = CoreDataHandler()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                PeerListView(
                    localFileManager: localFileManager, coreDataHandler: coreDataHandler
                )
            }
//            ContentView(coreDataHandler: coreDataHandler) 
        }
    }
}
