//
//  RatedPeerModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 06/11/24.
//

import Foundation
struct RatedPeerModel: Codable{
    var peerUserName: String
    var peerToRateUserName: String
    var peerToRateRating: Float
    var peerToRatePeerId: String
    var cloudKitRecordMetaData: Data?
    
    static let emptyData = RatedPeerModel(peerUserName: "", peerToRateUserName: "", peerToRateRating: 0.0, peerToRatePeerId: "")
}
