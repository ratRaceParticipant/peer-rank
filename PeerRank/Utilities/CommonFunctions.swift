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
    
    static func validatePeerData(peerDataModel: PeerModel) -> ValidationStatus {
        if peerDataModel.name.isEmpty || peerDataModel.initials.isEmpty {
            return .requiredFieldsError
        }
        if peerDataModel.name.count > 20 {
            return .peerNameError
        }
        if peerDataModel.initials.count > 3 {
            return .initialsError
        }
        return .noError
    }
    
    static func getInitialsFromName(name: String) -> String {
        let nameArray: [String] = name.components(separatedBy: " ")
        var initials: String = ""
        if nameArray.count == 1 {
            initials = String(nameArray[0].prefix(2))
        } else {
            for word in nameArray {
                if initials.count == Constants.maxInitialsLength {
                    return initials.uppercased()
                } else {
                    if let letter = word.first {
                        initials += String(letter)
                    }
                }
            }
        }
        return initials.uppercased()
    }
    static func formattedInstanceDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yyyy 'at' h:mm a"
            return formatter.string(from: date)
    }
}
