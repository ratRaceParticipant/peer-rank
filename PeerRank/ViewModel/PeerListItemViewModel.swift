//
//  PeerListItemViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import UIKit
class PeerListItemViewModel: ObservableObject {
    var localFileManager: LocalFileManager
    
    init(localFileManager: LocalFileManager) {
        self.localFileManager = localFileManager
    }
    func getImage(peerDataModel: PeerModel) -> UIImage?{
        guard !(peerDataModel.photoId == "") else {
            
            return nil
        }
        return localFileManager.getImage(id: peerDataModel.photoId)
    }
}
