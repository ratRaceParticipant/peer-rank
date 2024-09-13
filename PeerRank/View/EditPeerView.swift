//
//  EditPeerView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI
import PhotosUI

struct EditPeerView: View {
    @StateObject var vm: EditPeerViewModel
    var isUpdate: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    
    init(
        localFileManager: LocalFileManager,
        isUpdate: Bool = false,
        peerModel: PeerModel = PeerModel.emptyData,
        coreDataHandler: CoreDataHandler,
        peerImage: UIImage? = nil
    ) {
        self._vm = StateObject(
            wrappedValue: EditPeerViewModel(
                localFileManager: localFileManager,
                coreDatHandler: coreDataHandler,
                peerModel: peerModel,
                peerImage: peerImage
            )
        )
        self.isUpdate = isUpdate
        
        
    }
    
    var body: some View {
        ScrollView{
            VStack{
                PeerPhotoView(
                    peerDataModel: vm.peerModel,
                    selectedImage: $vm.peerImage,
                    enableEditing: true,
                    localFileManager: vm.localFileManager
                )
                    .padding(.bottom)
                HStack {
                    CommonViews.textField(bindingText: $vm.peerModel.name, placeholderText: "Name")
                        .frame(width: 250)
                        .padding(.leading)
                        
                    CommonViews.textField(bindingText: $vm.peerModel.initials, placeholderText: "Initials")
                        .limitInputLength(value: $vm.peerModel.initials, length: Constants.maxInitialsLength)
                        .padding(.trailing)
                }
                Divider()
                HStack(alignment: .center) {
                    PeerTypePickerView(pickerTypeId: $vm.peerModel.type)
                    Spacer()
                    RatingView(currentRating: $vm.peerRating)
                }
                .padding()
                RatingWeightageView(ratingWeightage: $vm.peerRatingWeightage)
                    .padding(.horizontal)
                Spacer()
                HStack {
                    Spacer()
                    Button("Save") {
                        vm.writePeerData(isUpdate: isUpdate)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.trailing)
                    .buttonBorderShape(.roundedRectangle)
                    
                }
                Spacer()
                
            }
        }
        //Need to utilise timers here
        .onChange(of: vm.peerModel.name) {
            vm.peerModel.initials = vm.getInitialsFromName(
                name: vm.peerModel.name
            )
        }
        .navigationTitle(isUpdate ? "Edit Peer Details" : "Add Peer")
    }
}

#Preview {
    NavigationStack{
        EditPeerView(
            localFileManager: LocalFileManager(), 
            coreDataHandler: CoreDataHandler()
        )
    }
}
