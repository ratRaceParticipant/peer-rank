//
//  EditPeerInstanceViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 14/09/24.
//

import Foundation
class EditPeerInstanceViewModel: ObservableObject {
    @Published var instanceRatingWeightage: Double = 1.0
    @Published var instanceRating: Float = 3.0
    @Published var peerInstanceModel: PeerInstanceModel
    var peerModel: PeerModel
    var coreDataHandler: CoreDataHandler
    
    init(
        peerModel: PeerModel,
        peerInstanceModel: PeerInstanceModel,
        coreDataHandler: CoreDataHandler
    ) {
        self.peerModel = peerModel
        self.peerInstanceModel = peerInstanceModel
        self.coreDataHandler = coreDataHandler
        self.instanceRating = Float(peerInstanceModel.instanceRating)
        self.instanceRatingWeightage = Double(peerInstanceModel.instanceRatingWeightage)
    }
    
    func writeToPeerInstance(isUpdate: Bool = false) {
        let peerEntity =  PeerModel.getEntityFromDataModelId(
            peerId: peerModel.peerId,
            viewContext: coreDataHandler.viewContext
        )
        
        
        let peerInstanceEntity = isUpdate ?
        PeerInstanceModel.getEntityFromDataModelId(id: peerInstanceModel.peerInstanceId, viewContext: coreDataHandler.viewContext) :
        PeerInstanceEntity(context: coreDataHandler.viewContext)
        guard let peerEntity, let peerInstanceEntity else {
            print("error updating instance data \(peerInstanceModel.peerInstanceId)")
            return
        }
        setData(isUpdate: isUpdate)
        PeerInstanceModel.mapModelToEntity(
            peerInstanceModel: peerInstanceModel,
            peerInstanceEntity: peerInstanceEntity
        )
        
        peerInstanceEntity.peer = peerEntity
        coreDataHandler.saveData()
        
        setAverageRating(peerEntity: peerEntity,peerInstanceEntity: peerInstanceEntity)
        
    }
    func setData(isUpdate: Bool){
        peerInstanceModel.id = UUID()
        peerInstanceModel.instanceRatingWeightage = Int16(instanceRatingWeightage)
        peerInstanceModel.instanceRating = Int16(instanceRating)
        if !isUpdate {
            peerInstanceModel.peerInstanceId = UUID().uuidString
        }
    }
    func setAverageRating(peerEntity: PeerEntity,peerInstanceEntity: PeerInstanceEntity){
        let averageRating = CommonFunctions.getPeerAverageRating(
            from: peerModel, viewContext: coreDataHandler.viewContext
        ) ?? peerModel.averageRating
        
        peerEntity.averageRating = averageRating
        peerInstanceEntity.averageRatingAtTimeOfInstance = averageRating
        coreDataHandler.saveData()
    }
}
