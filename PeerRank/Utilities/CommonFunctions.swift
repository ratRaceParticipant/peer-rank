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
        if peerDataModel.name.count > Constants.peerNameMaxLength {
            return .peerNameError
        }
        if peerDataModel.initials.count > Constants.peerInitialsMaxLength {
            return .initialsError
        }
        return .noError
    }
    
    static func validatePeerInstanceData(peerInstanceModel: PeerInstanceModel) -> ValidationStatus {
        if peerInstanceModel.instanceDescription.count > Constants.peerInstanceDescriptionMaxLength {
            return .peerInstanceDescriptionError
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
                if initials.count == Constants.peerInitialsMaxLength {
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
    static func deleteAllPeerData(coreDataHandler: CoreDataHandler) {
        do {
            let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
            let fetchedPeerEntityData =  try coreDataHandler.viewContext.fetch(request)
            for data in fetchedPeerEntityData {
                
                coreDataHandler.viewContext.delete(data)
            }
            coreDataHandler.saveData()
        } catch {
            print("error")
            }
    }
    
    static func setUserConfigToCache(userConfigModel: UserConfigModel){
        if let encodedData = try? JSONEncoder().encode(userConfigModel) {
            UserDefaults.standard.set(
                encodedData,
                forKey: Constants.userConfigModelUserDefaultKey
            )
        }
    }
    
    static func getUserConfigFromCache() -> UserConfigModel? {
        guard let data = UserDefaults.standard.data(forKey: Constants.userConfigModelUserDefaultKey) else {
            return nil
        }
        guard let savedItems = try? JSONDecoder().decode(UserConfigModel.self, from: data) else {
            return nil
        }
        return savedItems
    }
    
    static func regexValidate(inputToValidate input : String, regexPattern: String = "^[a-zA-Z0-9._]+$") -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regexPattern)
            let range = NSRange(location: 0, length: input.utf16.count)
            return regex.firstMatch(in: input, options: [], range: range) != nil
        } catch {
            print(error)
            return false
        }
    }
}
