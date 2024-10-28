//
//  CloudKitHandler.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 25/10/24.
//

import Foundation
import CloudKit
class CloudKitHandler {
    init(){
        
    }
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
            
            userConfigModel = UserConfigModel(
                iCloudConnectionStatus: iCloudConnectionStatus == .available ? .connected : .notConnected,
                userRecordId: ckRecordId.recordName,
                userName: fetchedData["userName"] ?? "",
                displayName: fetchedData["displayName"] ?? ""
            )
            
            CommonFunctions.setUserConfigToCache(
                userConfigModel: userConfigModel
            )
        } catch {
            throw error
        }
        
        
        return userConfigModel
    }
    
    private func fetchUserConfigData(userRecordId: String) async throws -> CKRecord{
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
            throw iCloudError.faliureFetchingRecord
        } catch {
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
    
    func mapUserConfigModelToCKRecord(
        from userConfigModel: UserConfigModel,
        to record: CKRecord = CKRecord(recordType: Constants.userConfigiCloudRecordName)
    ) -> CKRecord {
        record["userRecordId"] = userConfigModel.userRecordId
        record["userName"] = userConfigModel.userName
        record["displayName"] = userConfigModel.displayName
        return record
    }
    
    func mapCKRecordToUserConfigModel(record: CKRecord) -> UserConfigModel{
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
}
