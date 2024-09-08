//
//  PeerDetailViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import SwiftUI
class PeerDetailViewModel: ObservableObject {
    @Published var peerImage: UIImage?
    
    init(){
        getImage()
    }
    func getImage() {
        
    }
}
