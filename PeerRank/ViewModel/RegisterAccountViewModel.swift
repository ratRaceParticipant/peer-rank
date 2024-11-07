//
//  RegisterAccountViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 26/10/24.
//

import Foundation
@MainActor
class RegisterAccountViewModel: ObservableObject {
    
    var cloudKitHandler: CloudKitHandler = CloudKitHandler.shared
    @Published var userName: String = ""
    @Published var displayName: String = ""
    @Published var validationStatus: ValidationStatus = .noError
    @Published var userConfigModel: UserConfigModel
    @Published var registerLoadingStatus: LoadingStatus = .notStarted
    init(userConfigModel: UserConfigModel) {
        self.userConfigModel = userConfigModel
        self.userName = userConfigModel.userName ?? ""
        self.displayName = userConfigModel.displayName ?? ""
    }
    
    
    func writeUserConfigToiCloud(isUpdate: Bool = false) async {
        
        validationStatus = await validateData(isUpdate: isUpdate)
        guard validationStatus == .noError else {return}
//        print("Data correct")
        var userConfigModel = CommonFunctions.getUserConfigFromCache()
        do {
            if userConfigModel?.userRecordId.isEmpty ?? true {
                userConfigModel = try await cloudKitHandler.mapUserDataWithUserConfig()
            }
            guard var userConfigModel else {return}
            userConfigModel.userName = userName
            userConfigModel.displayName = displayName
            
            CommonFunctions.setUserConfigToCache(userConfigModel: userConfigModel)
            
            try await isUpdate ? cloudKitHandler.updateiCloudUserConfigRecord(userConfigModel: userConfigModel) : cloudKitHandler.writeToUserConfig(userConfigModel: userConfigModel)
            
        } catch {
            print("error at writeUserConfigToiCloud of RegisterAccountViewModel: \(error)")
        }
    }
    
    func validateData(isUpdate: Bool = false) async -> ValidationStatus {
        
        if userName.isEmpty || displayName.isEmpty {
            return .requiredFieldsError
        } else if userName.count > Constants.userNameMaxLength {
            return .userNameLengthError
        } else if displayName.count > Constants.displayNameMaxLength {
            return .displayNameLengthError
        } else if !CommonFunctions.regexValidate(inputToValidate: userName) {
            return .userNameInvalidCharacterError
        }
        if isUpdate {
            return .noError
        } else {
            do {
                let fetchedUserConfigData = try await CommonFunctions.fetchUserConfigDataWithUsername(
                    userName: userName,
                    cloudKitHandler: cloudKitHandler
                )
                if fetchedUserConfigData != nil {
                    return .userNameAlreadyExists
                }
            } catch {
                print("Error at validateData of RegisterAccountViewModel: \(error)")
            }
        }
        return .noError
    }
    
}
