//
//  PeerPhotoViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import Foundation
import PhotosUI
import SwiftUI

@MainActor
class PeerPhotoViewModel: ObservableObject {
    var localFileManager: LocalFileManager
    @Published var initials: String = ""
    @Published var photoPickerItem: PhotosPickerItem? = nil
    init(
        localFileManager: LocalFileManager
    ){
        self.localFileManager = localFileManager
        

    }
    func setImage(from selection: PhotosPickerItem?) async -> UIImage?{
        guard let selection else {return nil}
        
        guard let imageData = try? await selection.loadTransferable(type: Data.self), let uiImage = UIImage(data: imageData) else {return nil}
        return uiImage
        
    }
    
    func getInitials(name: String) -> String{
        let nameArray: [String] = name.components(separatedBy: " ")
        var initials: String = ""
        if nameArray.count == 1 {
            initials = String(nameArray[0].prefix(2))
        } else {
            for word in nameArray {
                if initials.count == Constants.maxInitialsLength {
                    return initials.uppercased()
                } else {
                    if let letter = word.first {
                        initials += String(letter).uppercased()
                    }
                }
            }
        }
        return initials.uppercased()
    }
    
}
