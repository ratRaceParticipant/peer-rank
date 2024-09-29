//
//  PeerBannerViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import Foundation
import CoreData
class PeerBannerViewModel: ObservableObject {
    
    var coreDataHandler: CoreDataHandler
    @Published var peerDataModel: [PeerModel] = PeerModel.sampleData
    init(coreDataHandler: CoreDataHandler) {
        self.coreDataHandler = coreDataHandler
    }
    
    func fetchBannerData(fetchTopRatedPeers: Bool = true){
        peerDataModel = CommonFunctions.fetchBannerData(
            fetchTopRatedPeers: fetchTopRatedPeers,
            viewContext: coreDataHandler.viewContext
        )
    }
}
