//
//  PeerInstanceModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import Foundation

struct PeerInstanceModel{
    init(instanceDate: Date, instanceRating: Int16, instanceRatingWeightage: Int16, instanceDescription: String) {
        self.instanceDate = instanceDate
        self.instanceRating = instanceRating
        self.instanceRatingWeightage = instanceRatingWeightage
        self.instanceDescription = instanceDescription
    }
    
    var instanceDate: Date
    var instanceRating: Int16
    var instanceRatingWeightage: Int16
    var instanceDescription: String
    
    static let emptyData = PeerInstanceModel(instanceDate: Date(), instanceRating: 3, instanceRatingWeightage: 1, instanceDescription: "")
}

extension PeerInstanceModel {
    static var sampleData: [PeerInstanceModel] = [
        PeerInstanceModel(instanceDate: Date(), instanceRating: 4, instanceRatingWeightage: 4, instanceDescription: "Sample Desc"),
        PeerInstanceModel(instanceDate: Date(), instanceRating: 5, instanceRatingWeightage: 1, instanceDescription: "Sample Desc"),
        PeerInstanceModel(instanceDate: Date(), instanceRating: 2, instanceRatingWeightage: 7, instanceDescription: "Sample Desc")
    ]
    
    static func mapModelToEntity(peerInstanceModel: PeerInstanceModel, peerInstanceEntity: PeerInstanceEntity) {
        
        peerInstanceEntity.instanceDate = peerInstanceModel.instanceDate
        
        peerInstanceEntity.instanceDescription = peerInstanceModel.instanceDescription
        peerInstanceEntity.instanceRating = peerInstanceModel.instanceRating
        peerInstanceEntity.isntanceRatingWeightage = peerInstanceModel.instanceRatingWeightage
    }
    static func mapEntityToModel(peerInstanceEntity: PeerInstanceEntity) -> PeerInstanceModel {
        PeerInstanceModel(
            instanceDate: peerInstanceEntity.instanceDate ?? Date(),
            instanceRating: peerInstanceEntity.instanceRating,
            instanceRatingWeightage: peerInstanceEntity.isntanceRatingWeightage,
            instanceDescription: peerInstanceEntity.instanceDescription ?? ""
        )
    }
}
