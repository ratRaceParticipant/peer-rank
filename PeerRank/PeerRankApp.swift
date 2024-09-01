//
//  PeerRankApp.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import SwiftUI

@main
struct PeerRankApp: App {
    var coreDataHandler: CoreDataHandler = CoreDataHandler()
    var body: some Scene {
        WindowGroup {
            ContentView(coreDataHandler: CoreDataHandler())
        }
    }
}
