//
//  PeerListViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 29/09/24.
//

import Foundation
@MainActor
class PeerListViewModel: ObservableObject {
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    @Published var peerModelData: [PeerModel] = []
    var fetchFromCoreData: Bool
    var numberOfDataToFetch: Int
    init(
        coreDataHandler: CoreDataHandler,
        localFileManager: LocalFileManager,
        peerModelData: [PeerModel],
        numberOfDataToFetch: Int = Constants.defaultNumberOfDataToFetch,
        fetchFromCoreData : Bool = true
    ) {
        self.peerModelData = peerModelData
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
        self.numberOfDataToFetch = numberOfDataToFetch
        self.fetchFromCoreData = fetchFromCoreData
    }
    
    func fetchData() async {
        if fetchFromCoreData {
            peerModelData = await CommonFunctions.fetchPeerData(
                viewContext: coreDataHandler.viewContext,
                localFileManager: localFileManager,
                numberofDataToFetch: numberOfDataToFetch
            )
        }
    }
}
