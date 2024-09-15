//
//  PeerInstanceModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import Foundation
import CoreData
struct PeerInstanceModel: Identifiable{
    init(id: UUID,instanceDate: Date, instanceRating: Int16, instanceRatingWeightage: Int16, instanceDescription: String) {
        self.id = id
        self.instanceDate = instanceDate
        self.instanceRating = instanceRating
        self.instanceRatingWeightage = instanceRatingWeightage
        self.instanceDescription = instanceDescription
    }
    var id: UUID
    var instanceDate: Date
    var instanceRating: Int16
    var instanceRatingWeightage: Int16
    var instanceDescription: String
    
    static let emptyData = PeerInstanceModel(id: UUID(),instanceDate: Date(), instanceRating: 3, instanceRatingWeightage: 1, instanceDescription: "")
}

extension PeerInstanceModel {
    static var sampleData: [PeerInstanceModel] = [
        PeerInstanceModel(id: UUID(), instanceDate: Date(), instanceRating: 4, instanceRatingWeightage: 4, instanceDescription: "Sample Desc"),
        PeerInstanceModel(id: UUID(), instanceDate: Date(), instanceRating: 5, instanceRatingWeightage: 1, instanceDescription: "Sample Desc"),
        PeerInstanceModel(id: UUID(), instanceDate: Date(), instanceRating: 2, instanceRatingWeightage: 7, instanceDescription: "Sample Desc")
    ]
    
    static func mapModelToEntity(peerInstanceModel: PeerInstanceModel, peerInstanceEntity: PeerInstanceEntity) {
        peerInstanceEntity.id = peerInstanceModel.id
        peerInstanceEntity.instanceDate = peerInstanceModel.instanceDate
        
        peerInstanceEntity.instanceDescription = peerInstanceModel.instanceDescription
        peerInstanceEntity.instanceRating = peerInstanceModel.instanceRating
        peerInstanceEntity.isntanceRatingWeightage = peerInstanceModel.instanceRatingWeightage
    }
    static func mapEntityToModel(peerInstanceEntity: PeerInstanceEntity) -> PeerInstanceModel {
        PeerInstanceModel(
            id: peerInstanceEntity.id ?? UUID(),
            instanceDate: peerInstanceEntity.instanceDate ?? Date(),
            instanceRating: peerInstanceEntity.instanceRating,
            instanceRatingWeightage: peerInstanceEntity.isntanceRatingWeightage,
            instanceDescription: peerInstanceEntity.instanceDescription ?? ""
        )
    }
    static func getEntityFromDataModelId(id: UUID, viewContext: NSManagedObjectContext) -> PeerInstanceEntity? {
        let request: NSFetchRequest<PeerInstanceEntity> = PeerInstanceEntity.fetchRequest()
        request.fetchLimit = 1
        let filter = NSPredicate(format: "id == %@", id as CVarArg)
        request.predicate = filter
        do {
            
            let peerInstanceEntityData =  try viewContext.fetch(request)
            
            return peerInstanceEntityData[0]
            
            
        } catch {
            print("Error fetching data")
        }
        return nil
    }
}
