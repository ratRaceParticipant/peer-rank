//
//  EditPeerViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import Foundation

class EditPeerViewModel: ObservableObject {
    
    func getInitialsFromName(name: String) -> String {
        let nameArray: [String] = name.components(separatedBy: " ")
        var initials: String = ""
        if nameArray.count == 1 {
            initials = String(nameArray[0].prefix(2))
        } else {
            for word in nameArray {
                if initials.count == Constants.maxInitialsLength {
                    return initials
                } else {
                    if let letter = word.first {
                        initials += String(letter).uppercased()
                    }
                }
            }
        }
        return initials
    }
}
