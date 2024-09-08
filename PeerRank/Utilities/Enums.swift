//
//  Enums.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import Foundation
import SwiftUI
enum PeerType: Int16, CaseIterable {
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
    func getBgColor() -> Color {
        switch self {
        case .friend:
            return .green
        case .colleague:
            return .red
        case .fatherSideRelative:
            return .blue
        case .motherSideRelative:
            return .pink
        
        }
    }
}

enum InfoText: String {
    case baseRatingWeightageInfo = "This gives the weightage to the base rating."
    case averageRating = "Rating of average of base rating and instance ratings"
}
