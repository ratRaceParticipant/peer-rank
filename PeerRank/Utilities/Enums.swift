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

enum PMError: Error {
    case runtimeError(String)
}
enum ValidationStatus: String, Equatable {
    case requiredFieldsError
    case peerNameError
    case initialsError
    case peerInstanceDescriptionError
    case noError
    func getValidationError() -> String{
        switch self {
        case .requiredFieldsError:
            return "All the fields are mandatory"
        case .initialsError:
            return "Initials should not be greater than \(Constants.peerInitialsMaxLength) letters"
        case .peerNameError:
            return "Peer name should not be greater than \(Constants.peerNameMaxLength) letters"
        case .peerInstanceDescriptionError:
            return "Description should not be more than \(Constants.peerInstanceDescriptionMaxLength) letters"
        case .noError:
            return ""
        
        }
    }
}

enum DataUnavailable{
    case chartData
    case kpiData
    case peerData
    case instanceData
    case peerDetailDataAuthenticationFailed
    func getDataUnavailableMap() -> [String:String]{
        switch self {
        case .chartData:
            return [
                "title": "Not Enough Data Available",
                "icon": "chart.xyaxis.line",
                "description": "Add Atleast 3 instances to see the chart"
            ]
        case .kpiData:
            return [
                "title": "Not Enough Data Available",
                "icon": "chart.bar.fill",
                "description": "Add Atleast 3 Peers to see the metrics"
            ]
        case .peerData:
            return [
                "title": "No Data Available",
                "icon": "person.fill.xmark",
                "description": "Add Peers to get started"
            ]
        case .instanceData:
            return [
                "title": "No Data Available",
                "icon": "square.grid.3x3.topleft.filled",
                "description": "Added instances will be visible here"
            ]
        case .peerDetailDataAuthenticationFailed:
            return [
                "title": "Data Hidden",
                "icon": "person.fill.xmark",
                "description": "Authentication Failed"
            ]
        }
    }
    
}
enum DataManagmentError {
    case exportJsonConversionError
    case tempFileDeletionError
    case importJsonConversionError
    func getMessage() -> String{
        switch self {
        case .exportJsonConversionError:
            return "Error in converting Json for exporting"
        case .tempFileDeletionError:
            return "Error in deleting temporary file"
        case .importJsonConversionError:
            return "Error in importing Json Data"
        }
    }
}

enum LoadingStatus {
    case notStarted
    case inprogress
    case complete
    case failed
    
    func getColor() -> Color{
        switch self{
        case .inprogress:
            return .yellow
        case .complete:
            return .green
        case .failed:
            return .red
        default :
            return .gray
        }
    }
    
    func getIcon() -> String {
        switch self{
        case .inprogress:
            return "checkmark"
        case .complete:
            return "checkmark"
        case .failed:
            return "multiply"
        default:
            return "exclamationmark"
        }
    }
    
    func getStatus() -> String {
        switch self{
        case .inprogress:
            return "In Progress"
        case .complete:
            return "Success"
        case .failed:
            return "Failed"
        case .notStarted:
            return "Not Started"
        }
    }
}
