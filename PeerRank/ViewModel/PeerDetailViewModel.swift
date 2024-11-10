//
//  PeerDetailViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import SwiftUI
import LocalAuthentication
class PeerDetailViewModel: ObservableObject {
    @Published var isUnlocked: Bool = false
    @Published var averageRating: Float = 0.0
    @Published var showDeleteConfirmation: Bool = false
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    var showDeleteAction: Bool
    @Published var ratedPeerModel: RatedPeerModel?
    var cloudKitHandler = CloudKitHandler.shared
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager, showDeleteAction: Bool) {
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
        self.showDeleteAction = showDeleteAction
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
    
    func deleteData(peerDataModel: PeerModel) async {
        let peerEntity = getPeerEntity(peerModel: peerDataModel)
        
        guard let peerEntity else {
            return
        }
        coreDataHandler.deleteData(entityToDelete: peerEntity)
        
        guard let ratedPeerModel else {return}
        
        do {
            try await cloudKitHandler.deleteRatedPeerRecord(ratedPeerModel: ratedPeerModel)
        } catch {
            print("Error at deleteData of PeerDetailViewModel: \(error)")
        }
    }
    
    func setRatedPeerData(peerModel: PeerModel) async -> RatedPeerModel?{
        if ratedPeerModel != nil {
            return ratedPeerModel
        }
        do {
            
            let fetchedData = try await CommonFunctions.fetchRatedPeerDataWithUsername(
                value: peerModel.peerId,
                key: "peerToRatePeerId",
                cloudKitHandler: cloudKitHandler
            )
            print("setRatedPeerData")
            guard let fetchedData else {return nil}
        
            return RatedPeerModel(
                peerUserName: fetchedData.peerUserName,
                peerToRateUserName: fetchedData.peerToRateUserName,
                peerToRateRating: fetchedData.peerToRateRating,
                peerToRatePeerId: peerModel.peerId,
                cloudKitRecordMetaData: fetchedData.cloudKitRecordMetaData
            )
        } catch {
            print("Error in setRatedPeerData of EditPeerViewModel: \(error)")
        }
        return nil
    }
    
    func authenticate(peerDataModel: PeerModel){
        if !peerDataModel.enableFaceId || isUnlocked {
            isUnlocked = true
            return
        }
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Authentication required to unlock passwords"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if success {
                    // authentication complete
                    DispatchQueue.main.async {
                        self.isUnlocked = true
                    }
                } else {
                    // problem in authentication
                    DispatchQueue.main.async {
                        self.isUnlocked = false
                    }
                }
            }
        } else {
            isUnlocked = true
            // no biometrics available
        }
    }
    
}
