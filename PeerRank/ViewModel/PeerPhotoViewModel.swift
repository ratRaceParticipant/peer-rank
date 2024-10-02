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
}
