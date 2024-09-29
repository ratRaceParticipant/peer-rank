//
//  PeerModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import Foundation
import CoreData
import SwiftUI

struct PeerModel: Identifiable{
    var id: UUID
    var peerId: String
    var initials: String
    var name: String
    var photoId: String
    var type: Int16
    var baseRating: Int16
    var baseRatingWeightage: Int16
    var averageRating: Float
    var peerInstance: [PeerInstanceModel]
    var peerImage: UIImage?
    init(id: UUID,peerId: String, initials: String, name: String, photoId: String, type: Int16, baseRating: Int16, baseRatingWeightage: Int16,
         averageRating: Float,peerInstance: [PeerInstanceModel]) {
        self.id = id
        self.peerId = peerId
        self.initials = initials
        self.name = name
        self.photoId = photoId
        self.type = type
        self.baseRating = baseRating
        self.baseRatingWeightage = baseRatingWeightage
        self.peerInstance = peerInstance
        self.averageRating = averageRating
    }
    static let emptyData = PeerModel(id: UUID(), peerId: UUID().uuidString, initials: "", name: "", photoId: "", type: 1, baseRating: 3, baseRatingWeightage: 5, averageRating: 3.0, peerInstance:  [])
}

extension PeerModel {
    static let sampleData: [PeerModel] = [
        PeerModel(id: UUID(), peerId: UUID().uuidString, initials: "HK", name: "Himanshu Bhai", photoId: "sampleid", type: 3, baseRating: 4, baseRatingWeightage: 10, averageRating: 4.5, peerInstance: PeerInstanceModel.sampleData),
        PeerModel(id: UUID(), peerId: UUID().uuidString, initials: "RJ", name: "Rohit Janwar", photoId: "sampleid", type: 2, baseRating: 4, baseRatingWeightage: 10, averageRating: 3.7, peerInstance: PeerInstanceModel.sampleData),
        PeerModel(id: UUID(), peerId: UUID().uuidString, initials: "RJ", name: "Name 3", photoId: "sampleid", type: 2, baseRating: 4, baseRatingWeightage: 10, averageRating: 2.5, peerInstance: PeerInstanceModel.sampleData)
    ]
    
    static func mapModelToEntity(peerModel: PeerModel, peerEntity: PeerEntity, coreDataHandler: CoreDataHandler){
        peerEntity.id = peerModel.id
        peerEntity.peerId = peerModel.peerId
        peerEntity.name = peerModel.name
        peerEntity.baseRating = peerModel.baseRating
        peerEntity.baseRatingWeightage = peerModel.baseRatingWeightage
        peerEntity.type = peerModel.type
        peerEntity.initials = peerModel.initials
        peerEntity.photoId = peerModel.photoId
        peerEntity.averageRating = peerModel.averageRating
        if(peerModel.peerInstance.isEmpty){
            
            peerEntity.peerInstance = []
        } else {
            let peerInstanceSet = NSSet(array: peerModel.peerInstance.map({ data in
                let peerInstanceEntity = PeerInstanceEntity(context: coreDataHandler.viewContext)
                PeerInstanceModel.mapModelToEntity(
                    peerInstanceModel: data,
                    peerInstanceEntity: peerInstanceEntity
                )
                
                
                return peerInstanceEntity
            })
            )
            peerEntity.peerInstance = peerInstanceSet
            
        }
    }
    
    static func mapEntityToModel(peerEntity: PeerEntity, context: NSManagedObjectContext) -> PeerModel {
        PeerModel(
            id: peerEntity.id ?? UUID(),
            peerId: peerEntity.peerId ?? UUID().uuidString,
            initials: peerEntity.initials ?? "",
            name: peerEntity.name ?? "",
            photoId: peerEntity.photoId ?? "",
            type: peerEntity.type,
            baseRating: peerEntity.baseRating,
            baseRatingWeightage: peerEntity.baseRatingWeightage,
            averageRating: peerEntity.averageRating,
            peerInstance: peerEntity.peerInstance?.map({ data in
                PeerInstanceModel.mapEntityToModel(
                    peerInstanceEntity: data as? PeerInstanceEntity ?? PeerInstanceEntity(context: context)
                )
            }) ?? []
        )
    }
    
    static func getEntityFromDataModelId(peerId: String, viewContext: NSManagedObjectContext) -> PeerEntity? {
        let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
        request.fetchLimit = 1
        let filter = NSPredicate(format: "peerId == %@", peerId)
        request.predicate = filter
        do {
            
            let peerEntityData =  try viewContext.fetch(request)
            guard !peerEntityData.isEmpty else {
                
                return nil
            }
            return peerEntityData[0]
            
            
        } catch {
            print("Error fetching data")
        }
        return nil
    }
    
}

