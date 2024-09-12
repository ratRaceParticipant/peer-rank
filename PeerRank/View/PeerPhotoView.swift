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
    @Binding var selectedImage: UIImage?
    var enableEditing: Bool = true
    var photoSize: CGFloat = 100
    init(
        peerDataModel: PeerModel,
        selectedImage: Binding<UIImage?>,
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
        self._selectedImage = selectedImage
        self.enableEditing = enableEditing
        self.photoSize = photoSize
        
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PhotosPicker(selection: $vm.photoPickerItem,matching: .images) {
                Group {
                    if let image = selectedImage {
                        profilePhoto(uiImage: image)
                            
                    } else {
                        initialsPlaceholder
                    }
                }
                .foregroundStyle(PeerType(rawValue: vm.peerDataModel.type)?.getBgColor() ?? .clear)
            }
            
            if enableEditing {
                editIcon
            }
        }
        .onAppear{
            selectedImage = vm.getImage()
        }
        .onChange(of: vm.photoPickerItem) {
            Task {
               selectedImage = await vm.setImage(from: vm.photoPickerItem)
            }
        }
        
    }
    func profilePhoto(uiImage: UIImage) -> some View {
        Image(uiImage: uiImage)
            .resizable()
            .scaledToFill()
            .frame(width: photoSize,height: photoSize)
            .contextMenu {
                if enableEditing {
                    Button {
                        selectedImage = nil
                    } label: {
                        Label("Delete image", systemImage: "trash.fill")
                    }
                }
            }
            .clipShape(.circle)
    }
    
    var initialsPlaceholder: some View {
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
    var editIcon: some View {
        Circle()
            .frame(
                width: 30,
                height: 30,
                alignment: .bottomTrailing
            )
            .foregroundStyle(.blue)
            .overlay {
                Image(systemName: "pencil")
                    .foregroundStyle(.white)
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