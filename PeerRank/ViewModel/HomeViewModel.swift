//
//  HomeViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import Foundation
class HomeViewModel: ObservableObject {
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager) {
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
    }
}
