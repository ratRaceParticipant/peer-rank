//
//  CommonFunctions.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 22/09/24.
//

import Foundation
import CoreData
import SwiftUI
class CommonFunctions {
    static func getPeerAverageRating(from peerModel: PeerModel,viewContext: NSManagedObjectContext) -> Float?{
        let peerEntityData = PeerModel.getEntityFromDataModelId(peerId: peerModel.peerId, viewContext: viewContext)
        guard let peerEntityData else {return nil}
        let allPeerModelData = PeerModel.mapEntityToModel(peerEntity: peerEntityData, context: viewContext)
        
        let initialBaseRating: Int = Int(allPeerModelData.baseRating * allPeerModelData.baseRatingWeightage)
        
        var sumOfInstanceRatings: Int = 0
        var numberOfInstances: Int = 0
        for instanceData in allPeerModelData.peerInstance {
            sumOfInstanceRatings += Int(instanceData.instanceRating * instanceData.instanceRatingWeightage)
            numberOfInstances += Int(instanceData.instanceRatingWeightage)
        }
        let averageRating =
        //        9 / 2
        
        Float(initialBaseRating + sumOfInstanceRatings) /
        Float(
            Int(allPeerModelData.baseRatingWeightage)
            + numberOfInstances)
//        print("base: \(initialBaseRating)")
//        print("sum of ins: \(sumOfInstanceRatings)")
//        print("divided by: \((Int(allPeerModelData.baseRatingWeightage) + numberOfInstances))")
        return averageRating
        
    }
    static func fetchBannerData(fetchTopRatedPeers: Bool = true, viewContext: NSManagedObjectContext) -> [PeerModel]{
        let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
        request.fetchLimit = 3
        let averageRatingSort = NSSortDescriptor(key:"averageRating", ascending: !fetchTopRatedPeers)
        request.sortDescriptors = [averageRatingSort]
        do {
            
            var data: [PeerModel] = []
            let peerEntityData =  try viewContext.fetch(request)
            for entityData in peerEntityData {
                let peerModelData =  PeerModel.mapEntityToModel(
                                            peerEntity: entityData,
                                            context: viewContext
                                    )
                data.append(
                   peerModelData
                )
            }
            return data
            
            
        } catch {
            print("Error fetching data")
        }
        return []
    }
    
    static func fetchPeerData(
        viewContext: NSManagedObjectContext,
        localFileManager: LocalFileManager?,
        numberofDataToFetch: Int = Constants.defaultNumberOfDataToFetch,
        sortDescriptors: [NSSortDescriptor]? = [NSSortDescriptor(key:"createdOn", ascending: false)],
        filter: NSPredicate?,
        mapPeerImage: Bool = true
    ) -> [PeerModel] {
        let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
        if let filter {
            request.predicate = filter
        }
        request.fetchLimit = numberofDataToFetch
        request.sortDescriptors = sortDescriptors
        do {
            var data: [PeerModel] = []
            let peerEntityData =  try viewContext.fetch(request)
            for entityData in peerEntityData {
                var peerModelData =  PeerModel.mapEntityToModel(
                                            peerEntity: entityData,
                                            context: viewContext
                                    )
                if mapPeerImage, let localFileManager {
                    
                    peerModelData.peerImage = CommonFunctions.getImageFromPhotoId(
                        from: peerModelData.photoId, localFileManager: localFileManager
                    )
                }
                data.append(
                   peerModelData
                )
            }
            return data
            
            
        } catch {
            print("Error fetching data")
        }
        return []
    }
    
    static func getImageFromPhotoId(from photoId: String, localFileManager: LocalFileManager) -> UIImage?{
        guard !(photoId == "") else {
            
            return nil
        }
        let image = localFileManager.getImage(id: photoId)
        
        return image
    }
    
//    static func validatePeerData(peerDataModel: PeerModel){
//
//    }
}
