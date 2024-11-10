//
//  MyRatingTabViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/11/24.
//

import Foundation
class MyRatingTabViewModel: ObservableObject {
    @Published var ratedPeerData: [RatedPeerModel] = []
    @Published var loadingStatus: LoadingStatus = .notStarted
    var currentUserConfig: UserConfigModel?
    init() {
        self.loadingStatus = .inprogress
        self.currentUserConfig = CommonFunctions.getUserConfigFromCache()
    }
    func fetchData() async {
        
        guard let userName = currentUserConfig?.userName else {
            return
        }
        
        do {
            let fetchedData = try await CloudKitHandler.shared.fetchRatedPeerData(
                predicate: NSPredicate(
                    format: "peerToRateUserName == %@",
                    userName
                )
            )
            await MainActor.run {
                ratedPeerData = fetchedData
            }
            
        } catch {
            print("Error in fetchData of MyRatingTabViewModel:\(error)")
        }
        return
    }
}
