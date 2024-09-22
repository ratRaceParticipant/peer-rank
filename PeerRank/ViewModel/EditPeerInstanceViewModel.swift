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
        guard let peerEntity else {return}
        
        let peerInstanceEntity = isUpdate ?
        PeerInstanceModel.getEntityFromDataModelId(id: peerInstanceModel.id, viewContext: coreDataHandler.viewContext) :
        PeerInstanceEntity(context: coreDataHandler.viewContext)
        
        setData()
        PeerInstanceModel.mapModelToEntity(
            peerInstanceModel: peerInstanceModel,
            peerInstanceEntity: peerInstanceEntity ?? PeerInstanceEntity(context: coreDataHandler.viewContext)
        )
        
        peerInstanceEntity?.peer = peerEntity
        coreDataHandler.saveData()
        
    }
    func setData(){
        peerInstanceModel.id = UUID()
        peerInstanceModel.instanceRatingWeightage = Int16(instanceRatingWeightage)
        peerInstanceModel.instanceRating = Int16(instanceRating)
    }
}
