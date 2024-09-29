//
//  HomeViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import Foundation
class HomeViewModel: ObservableObject {
    var coreDataHandler: CoreDataHandler
    init(coreDataHandler: CoreDataHandler) {
        self.coreDataHandler = coreDataHandler
    }
}
