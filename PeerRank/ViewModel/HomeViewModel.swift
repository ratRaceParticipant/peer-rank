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
    @Published var peerDataModel: [PeerModel] = []
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager) {
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
    }
    
    func fetchPeerData(){
        let data = CommonFunctions.fetchPeerData(
            viewContext: coreDataHandler.viewContext,
            localFileManager: nil,
            filter: nil,
            mapPeerImage: false
        )
        peerDataModel = data
    }
    
}
