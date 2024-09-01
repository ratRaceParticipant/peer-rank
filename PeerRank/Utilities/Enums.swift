//
//  Enums.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import Foundation
enum PeerType: Int16 {
    case friend = 1
    case colleague = 2
    case fatherSideRelative = 3
    case motherSideRelative = 4
    
    func getPeerTypeString()->String {
        switch self {
        case .friend:
            return "Friend"
        case .colleague:
            return "Colleague"
        case .fatherSideRelative:
            return "Father Side Relative"
        case .motherSideRelative:
            return "Mother Side Relative"
        
        }
    }
}
