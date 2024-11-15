//
//  PeerInstanceModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import Foundation
import CoreData
struct PeerInstanceModel: Identifiable, Codable{
    init(id: UUID,
         peerInstanceId: String,
         instanceDate: Date,
         instanceRating: Int16,
         instanceRatingWeightage: Int16,
         instanceDescription: String,
         averageRatingAtTimeOfInstance: Float
    ) {
        self.id = id
        self.peerInstanceId = peerInstanceId
        self.instanceDate = instanceDate
        self.instanceRating = instanceRating
        self.instanceRatingWeightage = instanceRatingWeightage
        self.instanceDescription = instanceDescription
        self.averageRatingAtTimeOfInstance = averageRatingAtTimeOfInstance
    }
    var id: UUID
    var peerInstanceId: String
    var instanceDate: Date
    var instanceRating: Int16
    var instanceRatingWeightage: Int16
    var instanceDescription: String
    var averageRatingAtTimeOfInstance: Float
    
    static let emptyData = PeerInstanceModel(
        id: UUID(),
        peerInstanceId: UUID().uuidString,
        instanceDate: Date(),
        instanceRating: 3,
        instanceRatingWeightage: 1,
        instanceDescription: "",
        averageRatingAtTimeOfInstance: 0.0
    )
}

extension PeerInstanceModel {
    static var sampleData: [PeerInstanceModel] = [
        PeerInstanceModel(
            id: UUID(),
            peerInstanceId: UUID().uuidString,
            instanceDate: Date(),
            instanceRating: 4,
            instanceRatingWeightage: 4,
            instanceDescription: "Sample Desc",
            averageRatingAtTimeOfInstance: 3.0
        ),
        PeerInstanceModel(
            id: UUID(),
            peerInstanceId: UUID().uuidString,
            instanceDate: Date(),
            instanceRating: 2,
            instanceRatingWeightage: 4,
            instanceDescription: "Sample Desc",
            averageRatingAtTimeOfInstance: 5.0
        ),
    ]
    
    static func mapModelToEntity(peerInstanceModel: PeerInstanceModel, peerInstanceEntity: PeerInstanceEntity) {
        peerInstanceEntity.id = peerInstanceModel.id
        peerInstanceEntity.peerInstanceId = peerInstanceModel.peerInstanceId
        peerInstanceEntity.instanceDate = peerInstanceModel.instanceDate
        peerInstanceEntity.instanceDescription = peerInstanceModel.instanceDescription
        peerInstanceEntity.instanceRating = peerInstanceModel.instanceRating
        peerInstanceEntity.isntanceRatingWeightage = peerInstanceModel.instanceRatingWeightage
        peerInstanceEntity.averageRatingAtTimeOfInstance = peerInstanceModel.averageRatingAtTimeOfInstance
    }
    static func mapEntityToModel(peerInstanceEntity: PeerInstanceEntity) -> PeerInstanceModel {
        PeerInstanceModel(
            id: peerInstanceEntity.id ?? UUID(),
            peerInstanceId:  peerInstanceEntity.peerInstanceId ?? UUID().uuidString,
            instanceDate: peerInstanceEntity.instanceDate ?? Date(),
            instanceRating: peerInstanceEntity.instanceRating,
            instanceRatingWeightage: peerInstanceEntity.isntanceRatingWeightage,
            instanceDescription: peerInstanceEntity.instanceDescription ?? "",
            averageRatingAtTimeOfInstance: peerInstanceEntity.averageRatingAtTimeOfInstance
        )
    }
    static func getEntityFromDataModelId(id: String, viewContext: NSManagedObjectContext) -> PeerInstanceEntity? {
        let request: NSFetchRequest<PeerInstanceEntity> = PeerInstanceEntity.fetchRequest()
        request.fetchLimit = 1
        let filter = NSPredicate(format: "peerInstanceId == %@", id)
        request.predicate = filter
        request.returnsObjectsAsFaults = false
        do {
            
            let peerInstanceEntityData =  try viewContext.fetch(request)
            guard !peerInstanceEntityData.isEmpty else {
                return nil
            }
            
            return peerInstanceEntityData[0]
            
            
        } catch {
            print("Error fetching data")
        }
        return nil
    }
}
