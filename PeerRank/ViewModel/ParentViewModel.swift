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
    var cloudKitHandler: CloudKitHandler = CloudKitHandler.shared
    init(
        coreDataHandler: CoreDataHandler,
        localFileManager: LocalFileManager
        
    ) {
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
    
    func mapiCloudUserDataWithUserConfig() async {
        do {
            let _ = try await cloudKitHandler.mapUserDataWithUserConfig()
        } catch {
            print(error)
        }
    }
    
}
