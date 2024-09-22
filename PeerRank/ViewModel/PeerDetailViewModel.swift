//
//  PeerDetailViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import SwiftUI
class PeerDetailViewModel: ObservableObject {
    @Published var averageRating: Float = 0.0
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager) {
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
    }
    
    func getAverageRatingToDisplay(peerModel: PeerModel){
        averageRating = CommonFunctions.getPeerAverageRating(from: peerModel, viewContext: coreDataHandler.viewContext)
        ?? peerModel.averageRating
    }
    
    func getUpdatedPeerModelData(peerModel: PeerModel) -> PeerModel{
        let peerEntity = PeerModel.getEntityFromDataModelId(peerId: peerModel.peerId, viewContext: coreDataHandler.viewContext)
        
        guard let peerEntity else {
            return peerModel
        }
        return PeerModel.mapEntityToModel(peerEntity: peerEntity, context: coreDataHandler.viewContext)
    }
}
