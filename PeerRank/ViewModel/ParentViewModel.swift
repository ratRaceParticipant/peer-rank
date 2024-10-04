//
//  ParentViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 03/10/24.
//

import Foundation
class ParentViewModel: ObservableObject {
    
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager) {
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
    }
    
    func isDataNull() -> Bool {
        let fetchedData = CommonFunctions.fetchPeerData(
            viewContext: coreDataHandler.viewContext,
            localFileManager: nil,
            filter: nil
        )
        return fetchedData.isEmpty
    }
    
}
