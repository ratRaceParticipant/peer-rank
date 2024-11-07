//
//  PeerSelectorViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/10/24.
//

import Foundation
class PeerSelectorViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var peersToSelect: [UserConfigModel] = []
    @Published var peerLinkingStatus: LoadingStatus = .notStarted
    @Published var peerLinkingErrorMessage: String = ""
    var currentUserConfig: UserConfigModel?
    var cloudKitHandler: CloudKitHandler = CloudKitHandler.shared
    var currentPeerModel: PeerModel
    
    init(peerModel: PeerModel){
        
        self.currentUserConfig = CommonFunctions.getUserConfigFromCache()
        self.currentPeerModel = peerModel
    }
    func fetchPeersToSelect() async -> String? {
        
        guard !(searchText == currentUserConfig?.userName) else {
            await MainActor.run {
                peerLinkingErrorMessage = PeerLinkingError.peerUserNameSameAsUserName.getMessage()
            }
            
            return nil
        }
        do {
            let data = try await cloudKitHandler.fetchUserConfigData(
                predicate: NSPredicate(format: "userName == %@",searchText)
            )
            await MainActor.run {
                peersToSelect = data
                peerLinkingErrorMessage = ""
            }
            guard !peersToSelect.isEmpty else {
                await MainActor.run {
                    peerLinkingErrorMessage = PeerLinkingError.peerUserNameNotFound.getMessage()
                }
                return nil
            }
            if await isPeerAlreadySelected() {
                await MainActor.run {
                    peerLinkingErrorMessage = PeerLinkingError.peerUserNameAlreadyLinked.getMessage()
                }
                return nil
            }
            return peersToSelect[0].userName
            
        } catch {
            print("Error at fetchPeersToSelect func in PeerSelectorViewModel: \(error)")
        }
        
        
        return nil
    }
    func isPeerAlreadySelected() async -> Bool {
        
        guard let userName = currentUserConfig?.userName else {
            return false
        }
        do {
            let fetchedData = try await cloudKitHandler.fetchRatedPeerData(
                predicate: NSPredicate(
                    format: "peerToRatePeerId != %@ AND peerToRateUserName == %@ AND peerUserName == %@",
                    currentPeerModel.peerId,searchText,userName
                )
            )
            print(fetchedData)
            return !fetchedData.isEmpty
            
        } catch {
            print("Error in isPeerAlreadySelected of PeerSelectorViewModel:\(error)")
        }
        return false
    }
}


