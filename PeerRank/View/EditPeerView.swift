//
//  EditPeerView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI
import PhotosUI

struct EditPeerView: View {
    @State var peerModel: PeerModel = PeerModel.emptyData
    @State var peerImage: UIImage?
    var body: some View {
        VStack{
            PeerPhotoView(selectedImage: $peerImage)
            HStack {
                CommonViews.textField(bindingText: $peerModel.name, placeholderText: "Name")
                    .frame(width: 250)
                    .padding(.leading)
                    
                CommonViews.textField(bindingText: $peerModel.initials, placeholderText: "Initials")
                    .padding(.trailing)
            }
            PeerTypePickerView(pickerTypeId: $peerModel.type)
            RatingView(currentRating: $peerModel.baseRating)
            Spacer()
            
        }
    }
}

#Preview {
    EditPeerView()
}
