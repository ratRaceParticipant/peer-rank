//
//  PeerModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import Foundation
import CoreData
struct PeerModel{
    var id: UUID
    var initials: String
    var name: String
    var photoId: String
    var type: Int16
    var baseRating: Int16
    var baseRatingWeightage: Int16
    var averageRating: Float
    var peerInstance: [PeerInstanceModel]
    init(id: UUID, initials: String, name: String, photoId: String, type: Int16, baseRating: Int16, baseRatingWeightage: Int16,
         averageRating: Float,peerInstance: [PeerInstanceModel]) {
        self.id = id
        self.initials = initials
        self.name = name
        self.photoId = photoId
        self.type = type
        self.baseRating = baseRating
        self.baseRatingWeightage = baseRatingWeightage
        self.peerInstance = peerInstance
        self.averageRating = averageRating
    }
}

extension PeerModel {
    static let sampleData: [PeerModel] = [
        PeerModel(id: UUID(), initials: "HK", name: "Himanshu Bhai", photoId: "sampleid", type: 1, baseRating: 4, baseRatingWeightage: 10, averageRating: 4.2, peerInstance: PeerInstanceModel.sampleData),
        PeerModel(id: UUID(), initials: "RJ", name: "Rohit Janwar", photoId: "sampleid", type: 1, baseRating: 4, baseRatingWeightage: 10, averageRating: 3.7, peerInstance: PeerInstanceModel.sampleData)
    ]
    
    static func mapModelToEntity(peerModel: PeerModel, peerEntity: PeerEntity, coreDataHandler: CoreDataHandler){
        peerEntity.id = peerModel.id
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
                print("Data: \(peerInstanceEntity.instanceDescription ?? "")")
                
                return peerInstanceEntity
            })
            )
            peerEntity.peerInstance = peerInstanceSet
            
        }
    }
    
    static func mapEntityToModel(peerEntity: PeerEntity, context: NSManagedObjectContext) -> PeerModel {
        PeerModel(
            id: peerEntity.id ?? UUID(),
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
}

