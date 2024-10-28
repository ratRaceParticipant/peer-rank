//
//  SettingViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 12/10/24.
//

import Foundation
@MainActor
class SettingViewModel: ObservableObject {
    var coreDataHandler: CoreDataHandler
    var cloudKitHandler: CloudKitHandler
    @Published var exportUrl: URL?
    @Published var showShareSheet: Bool = false
    @Published var presentFilePicker: Bool = false
    @Published var importingStatus: LoadingStatus = .notStarted
    @Published var isExporting: Bool = false
    @Published var userConfigModel: UserConfigModel?
    @Published var showRegisterSheet: Bool = false
    @Published var updateUserConfigData: Bool = false
    init(
        coreDataHandler: CoreDataHandler,
        cloudKitHandler: CloudKitHandler
    ) {
        self.coreDataHandler = coreDataHandler
        self.cloudKitHandler = cloudKitHandler
    }
    
    func exportDataToJsonFile(){
        do {
            let fetchedData = fetchPeerData()
            let encodedData = try JSONEncoder().encode(fetchedData)
            if let jsonString = String(data: encodedData, encoding: .utf8){
//                print(jsonString)
                if let tempUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                    let pathUrl = tempUrl.appending(path: Constants.exportedJsonTempFileName)
                    try jsonString.write(to: pathUrl, atomically: true, encoding: .utf8)
                    exportUrl = pathUrl
                    
                    showShareSheet = true
                }
            }
            
        } catch {
            
            print(DataManagmentError.exportJsonConversionError.getMessage(),error)
        }
    }
    
    func importDataFromJsonFile(_ url: URL){
        do {
            let jsonData = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode([PeerModel].self, from: jsonData)
            writeImportedDataToCoreData(peerDataModel: decodedData)
            importingStatus = .complete
            
        } catch {
            importingStatus = .failed
            print("\(DataManagmentError.importJsonConversionError.getMessage()): \(error)")
        }
    }
    
    func writeImportedDataToCoreData(peerDataModel: [PeerModel]) {
        CommonFunctions.deleteAllPeerData(coreDataHandler: coreDataHandler)
        for data in peerDataModel {
            let peerEntity = PeerEntity(context: coreDataHandler.viewContext)
            PeerModel.mapModelToEntity(peerModel: data, peerEntity: peerEntity, coreDataHandler: coreDataHandler)
            coreDataHandler.saveData()
        }
    }
  
    func getUrlForJsonToImport(result: Result<[URL], any Error>){
        switch result {
        case .success(let url):
            importingStatus = .inprogress
            guard !url.isEmpty else {
                importingStatus = .failed
                return
            }
            
            importDataFromJsonFile(url[0])
            
        case .failure(let faliure):
            importingStatus = .failed
            print(faliure.localizedDescription)
        }
        
    }
    
    func deleteTempFile(){
        guard let exportUrl else {return}
        do {
            try FileManager.default.removeItem(at: exportUrl)
        } catch {
            print(DataManagmentError.tempFileDeletionError.getMessage())
        }
    }
    
    func fetchPeerData() -> [PeerModel]{
        let data = CommonFunctions.fetchPeerData(
            viewContext: coreDataHandler.viewContext,
            localFileManager: nil,
            filter: nil,
            mapPeerImage: false
        )
        return data
    }
    
    func refreshUserConfig() async {
        userConfigModel = CommonFunctions.getUserConfigFromCache()
        do {
            userConfigModel = try await cloudKitHandler.mapUserDataWithUserConfig()
        } catch {
            print(error)
        }
        
//        print("user name: \(userConfigModel)")
    }
}
