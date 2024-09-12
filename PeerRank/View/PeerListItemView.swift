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
    init(
        localFileManager: LocalFileManager,
        peerDataModel: PeerModel = PeerModel.sampleData[0]
    ) {
        self._vm = StateObject(
            wrappedValue: PeerListItemViewModel(
                localFileManager: localFileManager
            )
        )
        self.peerDataModel = peerDataModel
    }
    var body: some View {
        HStack {
            PeerPhotoView(
                peerDataModel: peerDataModel, 
                selectedImage: .constant(vm.getImage(peerDataModel: peerDataModel)),
                
                enableEditing: false,
                photoSize: 75,
                localFileManager: vm.localFileManager
            )
            VStack(alignment: .leading) {
                Text(peerDataModel.name)
                    .fontWeight(.bold)
                    .font(.title3)
                RatingView(
                    currentRating: .constant(peerDataModel.averageRating),
                    enableEditing: false,
                    starFont: .title3
                )
                
            }
            Spacer()
            
        }
//        .padding(.horizontal,8)
    }
}

#Preview {
    PeerListItemView(localFileManager: LocalFileManager())
}
