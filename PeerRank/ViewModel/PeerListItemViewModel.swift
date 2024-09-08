//
//  PeerListItemViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
class PeerListItemViewModel: ObservableObject {
    var localFileManager: LocalFileManager
    @Published var peerDataModel: PeerModel
    
    init(localFileManager: LocalFileManager, peerDataModel: PeerModel) {
        self.localFileManager = localFileManager
        self.peerDataModel = peerDataModel
    }
}
