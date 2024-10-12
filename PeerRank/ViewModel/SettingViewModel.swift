//
//  SettingViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 12/10/24.
//

import Foundation
class SettingViewModel: ObservableObject {
    var coreDataHandler: CoreDataHandler
    
    init(coreDataHandler: CoreDataHandler) {
        self.coreDataHandler = coreDataHandler
    }
    
}
