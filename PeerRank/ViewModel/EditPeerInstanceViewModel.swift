//
//  EditPeerInstanceViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 14/09/24.
//

import Foundation

@MainActor
class EditPeerInstanceViewModel: ObservableObject {
    @Published var instanceRatingWeightage: Double = 1.0
    @Published var instanceRating: Float = 3.0
    @Published var peerInstanceModel: PeerInstanceModel
    @Published var showDeleteConfirmation: Bool = false
    @Published var validationStatus: ValidationStatus = .noError
    @Published var dataWriteStatus: LoadingStatus = .notStarted
    var peerModel: PeerModel
    var coreDataHandler: CoreDataHandler
    var ratedPeerModel: RatedPeerModel?
    init(
        peerModel: PeerModel,
        peerInstanceModel: PeerInstanceModel,
        coreDataHandler: CoreDataHandler,
        ratedPeerModel: RatedPeerModel?
    ) {
        self.peerModel = peerModel
        self.peerInstanceModel = peerInstanceModel
        self.coreDataHandler = coreDataHandler
        self.instanceRating = Float(peerInstanceModel.instanceRating)
        self.instanceRatingWeightage = Double(peerInstanceModel.instanceRatingWeightage)
        self.ratedPeerModel = ratedPeerModel
    }
    
    func writeToPeerInstance(isUpdate: Bool) async {
        
        dataWriteStatus = .inprogress
        validationStatus = CommonFunctions.validatePeerInstanceData(peerInstanceModel: peerInstanceModel)
        
        guard validationStatus == .noError else {
            return
        }
        
        let peerEntity =  PeerModel.getEntityFromDataModelId(
            peerId: peerModel.peerId,
            viewContext: coreDataHandler.viewContext
        )
        
        print("id: \(peerInstanceModel.peerInstanceId)")
        let peerInstanceEntity = isUpdate ?
        getPeerInstanceEntity() :
        PeerInstanceEntity(context: coreDataHandler.viewContext)
        print("instance: \(peerInstanceEntity)")
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
        await writeToRatedPeerData()
        dataWriteStatus = .notStarted
        
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
        ratedPeerModel?.peerToRateRating = averageRating
    }
    func getPeerInstanceEntity() -> PeerInstanceEntity? {
        PeerInstanceModel.getEntityFromDataModelId(id: peerInstanceModel.peerInstanceId, viewContext: coreDataHandler.viewContext)
    }
    
    private func writeToRatedPeerData() async {
        guard let ratedPeerModel else {return}
        do {
            try await CloudKitHandler.shared.writeToRatedPeerModel(ratedPeerModel: ratedPeerModel)
        } catch {
            print("Error at writeToRatedPeerData of EditPeerInstanceViewModel: \(error)")
        }
    }
    
    func deleteData() async {
        let peerInstanceEntity = getPeerInstanceEntity()
        
        guard let peerInstanceEntity else {
            return
        }
        coreDataHandler.deleteData(entityToDelete: peerInstanceEntity)
        await writeToRatedPeerData()
    }
}
