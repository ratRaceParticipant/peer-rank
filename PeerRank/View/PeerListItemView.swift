//
//  PeerListItemView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI

struct PeerListItemView: View {
    @StateObject var vm: PeerListItemViewModel
    var peerDataModel: PeerModel
    var peerImage: UIImage?
    init(
        localFileManager: LocalFileManager,
        peerDataModel: PeerModel = PeerModel.sampleData[0],
        peerImage: UIImage? = nil
        
    ) {
        self._vm = StateObject(
            wrappedValue: PeerListItemViewModel(
                localFileManager: localFileManager
            )
        )
        self.peerDataModel = peerDataModel
        self.peerImage = peerImage
    }
    var body: some View {
        HStack {
            PeerPhotoView(
                peerDataModel: peerDataModel, 
                selectedImage: .constant(peerImage),
                
                enableEditing: false,
                photoSize: 75,
                localFileManager: vm.localFileManager
            )
            VStack(alignment: .leading) {
                Text(peerDataModel.name)
                    .fontWeight(.bold)
                    .font(.title3)
                if !peerDataModel.enableFaceId {
                    RatingView(
                        currentRating: .constant(peerDataModel.averageRating),
                        enableEditing: false,
                        starFont: .title3
                    )
                }
                
            }
            Spacer()
            if peerDataModel.enableFaceId {
                Image(systemName: "lock.fill")
            }
            
        }
//        .padding(.horizontal,8)
    }
}

#Preview {
    PeerListItemView(localFileManager: LocalFileManager())
}
