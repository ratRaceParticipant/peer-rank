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
    case userNameLengthError
    case displayNameLengthError
    case userNameInvalidCharacterError
    case userNameAlreadyExists
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
        case .userNameLengthError:
            return "Username should not be more than \(Constants.userNameMaxLength) letters"
        case .displayNameLengthError:
            return "Display name should not be more than \(Constants.displayNameMaxLength) letters"
        case .userNameInvalidCharacterError:
            return "Username can only contain \".\" &  \"_\" other than alphanumeric values"
        case .userNameAlreadyExists:
            return "Username already exists."
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
    case ratedPeerData
    case iCloudConnection
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
        case .ratedPeerData:
            return [
                "title": "No Data Available",
                "icon": "person.fill.xmark",
                "description": "Seems like no one has linked your account as a peer."
            ]
        case .iCloudConnection:
            return [
                "title": "Unable to fetch data",
                "icon": "exclamationmark.icloud",
                "description": "Either device is not connected with iCloud, or user is not registerd"
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
enum iCloudConnectionStatus: String, Codable {
    case connected = "Connected"
    case notConnected = "Not Connected"
}
enum iCloudError: Error, CustomStringConvertible {
    case faliureFetchingAccountStatus
    case faliureFetchingUserId
    case faliureWritingRecord
    case faliureFetchingRecord
    case faliureUpdatingRecord
    case faliureExtractingRecordFromMetaData
    case connectionTimeout
    case faliureDeletingRecord
    public var description: String {
        switch self{
        case .faliureFetchingAccountStatus:
            return "Error in fetching iCloud Account Status"
        case .faliureFetchingUserId:
            return "Error in fetching iCloud User id"
        case .faliureWritingRecord:
            return "Error in writing data to iCloud"
        case .faliureFetchingRecord:
            return "Error in fetching data from iCloud"
        case .faliureUpdatingRecord:
            return "Error in updating data in iCloud"
        case .faliureExtractingRecordFromMetaData:
            return "Error in extracting record data from meta data"
        case .connectionTimeout:
            return "Connection Timeout"
        case .faliureDeletingRecord:
            return "Error in deleting iCloud Record"
        }
    }
}
enum PeerLinkingError {
    case peerUserNameSameAsUserName, peerUserNameNotFound, peerUserNameAlreadyLinked
    func getMessage() -> String {
        switch self {
        case .peerUserNameNotFound:
            return "Username not found"
        case .peerUserNameSameAsUserName:
            return "Peer username cannot be same as user's username"
        case .peerUserNameAlreadyLinked:
            return "Username is already linked with some other peer"
        }
        
    }
}
enum iCloudDetailsToMap {
    case userId, accountStatus, userNameAndDisplayName, allData
    
}
enum WarningType: String {
    case userNameCanBeEditedOnce = "Username will not be editable after registration."
    case peerLinkingNotAvailable = "Peer linking is not available as either app is not connected to iCloud or the registration is not complete.\nGo to settings to check the status or register."
}
