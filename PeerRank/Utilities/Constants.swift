//
//  Constants.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import Foundation

class Constants {
    static let dataSourceName = "PeerRankDataModel"
    static let appGroup = "group.com.ratRaceParticipant.Peer-Rank"
    static let defaultNumberOfDataToFetch: Int = 4
    static let peerNameMaxLength = 30
    static let peerInitialsMaxLength = 3
    static let peerInstanceDescriptionMaxLength = 1000
    static let exportedJsonTempFileName: String = "Peer Rank Export - \(Date().formatted(date: .complete, time: .omitted)).json"
    
}
