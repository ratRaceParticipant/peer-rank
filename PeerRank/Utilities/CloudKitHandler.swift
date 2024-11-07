//
//  CloudKitHandler.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 25/10/24.
//

import Foundation
import CloudKit
class CloudKitHandler {
    private init(){
        
    }
    static let shared = CloudKitHandler()
    private let container = CKContainer.default()
    private var database: CKDatabase {
        return container.publicCloudDatabase
    }
    private var userConfigModel = UserConfigModel()
    func mapUserDataWithUserConfig(iCloudDetailsToMap: iCloudDetailsToMap = .allData) async throws -> UserConfigModel? {
        let iCloudConnectionStatus: CKAccountStatus
        
        do {
            iCloudConnectionStatus = try await container.accountStatus()
        } catch {
            throw iCloudError.faliureFetchingAccountStatus
        }
        let ckRecordId: CKRecord.ID? = try await fetchiCloudUserId()
        
        guard let ckRecordId = ckRecordId else {
            throw iCloudError.faliureFetchingUserId
        }
        do {
            let fetchedData = try await fetchUserConfigData(userRecordId: ckRecordId.recordName)
            
            if let fetchedData {
                userConfigModel = UserConfigModel(
                    iCloudConnectionStatus: iCloudConnectionStatus == .available ? .connected : .notConnected,
                    userRecordId: ckRecordId.recordName,
                    userName: fetchedData["userName"] ?? "",
                    displayName: fetchedData["displayName"] ?? ""
                )
            } else {
                userConfigModel = UserConfigModel(
                    iCloudConnectionStatus: iCloudConnectionStatus == .available ? .connected : .notConnected,
                    userRecordId: ckRecordId.recordName
                )
            }
            CommonFunctions.setUserConfigToCache(
                userConfigModel: userConfigModel
            )
        } catch {
            throw error
        }
        
        
        return userConfigModel
    }
    
    private func fetchUserConfigData(userRecordId: String) async throws -> CKRecord?{
        let predicate = NSPredicate(format: "userRecordId == %@", userRecordId)
        let query = CKQuery(recordType: Constants.userConfigiCloudRecordName, predicate: predicate)
        
        do {
            let (results,_) = try await database.records(matching: query)
            
            for (_, result) in results {
                switch result {
                case .success(let record):
//                    print(record)
                    return record
                case .failure(_):
                    throw iCloudError.faliureFetchingRecord
                }
            }
            return nil
        } catch {
//            throw error
            throw iCloudError.faliureFetchingRecord
        }
    }
    
    func updateiCloudUserConfigRecord(userConfigModel: UserConfigModel) async throws {
        let predicate = NSPredicate(format: "userRecordId == %@", userConfigModel.userRecordId)
        let query = CKQuery(recordType: Constants.userConfigiCloudRecordName, predicate: predicate)
        
        do {
            let (results,_) = try await database.records(matching: query)
            
            for (_, result) in results {
                switch result {
                case .success(let record):
                    let recordToUpdate = mapUserConfigModelToCKRecord(from: userConfigModel, to: record)
                    try await database.save(recordToUpdate)
                case .failure(_):
                    throw iCloudError.faliureUpdatingRecord
                }
            }
            
        } catch {
            throw iCloudError.faliureUpdatingRecord
        }
    }
    
    func writeToUserConfig(userConfigModel: UserConfigModel) async throws {
        let recordToWrite = mapUserConfigModelToCKRecord(from: userConfigModel)
        try await saveDataToCloudKit(record: recordToWrite)
    }
    
    func writeToRatedPeerModel(
        ratedPeerModel: RatedPeerModel
    ) async throws {
        print("writeToRatedPeerModel")
        let recordToWrite = try mapRatedPeerModelToCKRecord(from: ratedPeerModel)
        try await saveDataToCloudKit(record: recordToWrite)
    }
    
    private func mapRatedPeerModelToCKRecord(from ratedPeermodel: RatedPeerModel) throws -> CKRecord {
        let record: CKRecord = try extractCloudRecord(from: ratedPeermodel) ?? CKRecord(recordType: Constants.ratedPeeriCloudRecordName)
        record["peerUserName"] = ratedPeermodel.peerUserName
        record["peerToRateUserName"] = ratedPeermodel.peerToRateUserName
        record["peerToRateRating"] = ratedPeermodel.peerToRateRating
        record["peerToRatePeerId"] = ratedPeermodel.peerToRatePeerId
        return record
    }
    
    private func mapCKRecordToRatedPeerModel(
        from record: CKRecord
    ) -> RatedPeerModel{
        let coder = NSKeyedArchiver(requiringSecureCoding: true)
            record.encodeSystemFields(with: coder)
        return RatedPeerModel(
            peerUserName: record["peerUserName"] ?? "",
            peerToRateUserName: record["peerToRateUserName"] ?? "",
            peerToRateRating: record["peerToRateRating"] ?? 0.0,
            peerToRatePeerId: record["peerToRatePeerId"] ?? "",
            cloudKitRecordMetaData: coder.encodedData
        )
    }
    
    private func mapUserConfigModelToCKRecord(
        from userConfigModel: UserConfigModel,
        to record: CKRecord = CKRecord(recordType: Constants.userConfigiCloudRecordName)
    ) -> CKRecord {
        record["userRecordId"] = userConfigModel.userRecordId
        record["userName"] = userConfigModel.userName
        record["displayName"] = userConfigModel.displayName
        return record
    }
    
    private func mapCKRecordToUserConfigModel(record: CKRecord) -> UserConfigModel{
        userConfigModel.userName = record["userName"] ?? ""
        userConfigModel.displayName = record["displayName"] ?? ""
        userConfigModel.userRecordId = record["userRecordId"] ?? ""
        return userConfigModel
    }
    
    private func saveDataToCloudKit(record: CKRecord) async throws {
        let dataBase = container.publicCloudDatabase
        do {
            try await dataBase.save(record)
        } catch {
            throw iCloudError.faliureWritingRecord
        }
    }
    
    private func setICloudStatus() async throws {
        do {
            let iCloudAccountStatus = try await container.accountStatus()
            CommonFunctions.setUserConfigToCache(
                userConfigModel: UserConfigModel(
                    iCloudConnectionStatus: iCloudAccountStatus == .available ? .connected : .notConnected
                )
            )
        } catch {
            throw iCloudError.faliureFetchingAccountStatus
        }
    }
    
    private func fetchiCloudUserId() async throws -> CKRecord.ID?{
        do {
           return try await container.userRecordID()
        } catch {
            throw iCloudError.faliureFetchingUserId
//            print(error)
//            return
        }
    }
    private func fetchData(
        from recordType: String = Constants.userConfigiCloudRecordName,
        filter predicate: NSPredicate = NSPredicate(value: true),
        resultLimit: Int = 1
    ) async throws -> [CKRecord]{
        let predicate = predicate
        let query = CKQuery(recordType: recordType, predicate: predicate)
        
        do {
            
            let (results,_) = try await database.records(matching: query,resultsLimit: resultLimit)
            print("fetchData")
            var fetchedRecords: [CKRecord] = []
            for (_, result) in results {
                switch result {
                case .success(let record):
//                    print(record)
                    fetchedRecords.append(record)
                case .failure(let error):
                    throw error
                }
            }
            return fetchedRecords
        } catch {
            throw error
        }
    }
    
    func fetchUserConfigData(
        predicate: NSPredicate = NSPredicate(value: true),
        resultsLimit: Int = 100
    ) async throws -> [UserConfigModel] {
        let fetchedData = try await fetchData( filter: predicate, resultLimit: resultsLimit)
        var userConfigModelData: [UserConfigModel] = []
        for data in fetchedData {
            userConfigModelData.append(mapCKRecordToUserConfigModel(record: data))
        }
        return userConfigModelData
    }
    
    func fetchRatedPeerData(
        predicate: NSPredicate = NSPredicate(value: true),
        resultsLimit: Int = 100
    ) async throws -> [RatedPeerModel] {
        
        let fetchedData = try await fetchData(from: Constants.ratedPeeriCloudRecordName, filter: predicate, resultLimit: resultsLimit)
        
        var ratedPeerModelData: [RatedPeerModel] = []
        for data in fetchedData {
            ratedPeerModelData.append(mapCKRecordToRatedPeerModel(from: data))
        }
        return ratedPeerModelData
    }
    private func extractCloudRecord(from ratedPeerModel: RatedPeerModel) throws -> CKRecord? {
        
        guard let metadata = ratedPeerModel.cloudKitRecordMetaData else {
            return nil
        }
        print("extractCloudRecord")
        do {
            let coder = try NSKeyedUnarchiver(forReadingFrom: metadata)
            let record = CKRecord(coder: coder)
            coder.finishDecoding()
            
            return record
        } catch {
            throw iCloudError.faliureExtractingRecordFromMetaData
        }
        
    }
}
