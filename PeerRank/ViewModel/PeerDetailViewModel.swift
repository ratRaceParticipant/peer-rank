//
//  PeerDetailViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import SwiftUI
class PeerDetailViewModel: ObservableObject {
 
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager) {
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
    }
}
