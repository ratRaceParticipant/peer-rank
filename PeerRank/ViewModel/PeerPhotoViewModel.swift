//
//  PeerPhotoViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI

class PeerPhotoViewModel: ObservableObject {
    @Published var peerDataModel: PeerModel
    var localFileManager: LocalFileManager
    @Published var photoPickerItem: PhotosPickerItem? = nil
    @Published var selectedUIimage: UIImage?
    init(peerDataModel: PeerModel, localFileManager: LocalFileManager){
        self.localFileManager = localFileManager
        self.peerDataModel = peerDataModel
        getImage(uuid: peerDataModel.photoId)
    }
    
    func setImage(from selection: PhotosPickerItem?) async {
        guard let selection else {return}
        
        guard let imageData = try? await selection.loadTransferable(type: Data.self), let uiImage = UIImage(data: imageData) else {return}
        selectedUIimage = uiImage
    }
    
    func getInitials(){
        let nameArray: [String] = peerDataModel.name.components(separatedBy: " ")
        var initials: String = ""
        if nameArray.count == 1 {
            initials = String(nameArray[0].prefix(2))
        } else {
            for word in nameArray {
                if initials.count == Constants.maxInitialsLength {
                    peerDataModel.initials = initials
                } else {
                    if let letter = word.first {
                        initials += String(letter).uppercased()
                    }
                }
            }
        }
        peerDataModel.initials = initials
    }
    
    func getImage(uuid: String){
        
    }
}
