//
//  UserConfigModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 25/10/24.
//

import Foundation
struct UserConfigModel: Codable{
    var iCloudConnectionStatus: iCloudConnectionStatus
    var userRecordId: String
    var userName: String?
    var displayName: String?
    init(
        iCloudConnectionStatus: iCloudConnectionStatus = .notConnected,
        userRecordId: String = "",
        userName: String? = nil,
        displayName: String? = nil
    ) {
        self.iCloudConnectionStatus = iCloudConnectionStatus
        self.userRecordId = userRecordId
        self.userName = userName
        self.displayName = displayName
    }
    
}
