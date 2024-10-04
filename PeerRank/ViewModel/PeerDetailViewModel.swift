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
    @Published var showDeleteConfirmation: Bool = false
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
        let peerEntity = getPeerEntity(peerModel: peerModel)
        
        guard let peerEntity else {
            return peerModel
        }
        return PeerModel.mapEntityToModel(peerEntity: peerEntity, context: coreDataHandler.viewContext)
    }
    
    func getPeerEntity(peerModel: PeerModel) -> PeerEntity? {
        PeerModel.getEntityFromDataModelId(peerId: peerModel.peerId, viewContext: coreDataHandler.viewContext)
    }
    
    func deleteData(peerDataModel: PeerModel){
        let peerEntity = getPeerEntity(peerModel: peerDataModel)
        
        guard let peerEntity else {
            return
        }
        coreDataHandler.deleteData(entityToDelete: peerEntity)
    }
    
}
