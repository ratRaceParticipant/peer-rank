//
//  PeerPhotoView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI
import PhotosUI

struct PeerPhotoView: View {
    @StateObject var vm: PeerPhotoViewModel
//    @Binding var selectedImage: UIImage?
    var enableEditing: Bool = true
    var photoSize: CGFloat = 100
    init(
        peerDataModel: PeerModel,
        selectedImage: Binding<UIImage?> = .constant(nil),
        enableEditing: Bool = true,
        photoSize: CGFloat = 100,
        localFileManager: LocalFileManager
    ) {
        _vm = StateObject(
            wrappedValue: PeerPhotoViewModel(
                peerDataModel: peerDataModel,
                localFileManager: localFileManager
            )
        )
//        self._selectedImage = selectedImage
        self.enableEditing = enableEditing
        self.photoSize = photoSize
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PhotosPicker(selection: $vm.photoPickerItem,matching: .images) {
                Group {
                    if let image = vm.selectedUIimage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: photoSize,height: photoSize)
                            .clipShape(.circle)
                    } else {
                        Circle()
                            .frame(width: photoSize,height: photoSize)
                            .foregroundStyle(.tertiary)
                            .overlay {
                                Group {
                                    if vm.peerDataModel.initials.isEmpty {
                                        Image(systemName: "camera")
                                            .foregroundStyle(.primary)
                                            .font(.headline)
                                    } else {
                                        Text(vm.peerDataModel.initials)
                                            .foregroundStyle(.primary)
                                            .font(.largeTitle)
                                    }
                                }
                            }
                    }
                }
                .foregroundStyle(PeerType(rawValue: vm.peerDataModel.type)?.getBgColor() ?? .clear)
            }
            
            if enableEditing {
                Circle()
                    .frame(width: 30,height: 30,alignment: .bottomTrailing)
                    .foregroundStyle(.blue)
                    .overlay {
                        Image(systemName: "pencil")
                            .foregroundStyle(.white)
                    }
            }
        }
        .onChange(of: vm.photoPickerItem) {
            Task {
                await vm.setImage(from: vm.photoPickerItem)
            }
        }
        
    }
}

#Preview {
    PeerPhotoView(
        peerDataModel: PeerModel.sampleData[0],
        selectedImage: .constant(nil),
        localFileManager: LocalFileManager()
    )
}
