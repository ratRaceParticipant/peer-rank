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
        peerImage: UIImage? = nil,
        ratedPeerModel: RatedPeerModel? = nil,
        updateParentVarData: ((_ peerDataModel: PeerModel, _ peerImage: UIImage?) -> Void)? = nil
    ) {
        
        self._vm = StateObject(
            wrappedValue: EditPeerViewModel(
                localFileManager: localFileManager,
                coreDatHandler: coreDataHandler,
                peerModel: peerModel,
                peerImage: peerImage,
                ratedPeerModel: ratedPeerModel,
                onChange: updateParentVarData
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
                        .limitInputLength(value: $vm.peerModel.initials, length: Constants.peerNameMaxLength)
                        .padding(.leading)
                        
                    CommonViews.textField(bindingText: $vm.peerModel.initials, placeholderText: "Initials")
                        .limitInputLength(value: $vm.peerModel.initials, length: Constants.peerInitialsMaxLength)
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
                Toggleview(label: "Enable Face Id for this Peer?", isToggleOn: $vm.peerModel.enableFaceId)
                    .padding([.horizontal,.bottom])
                PeerSelectorView(
                    selectedPeerUserName: $vm.selectedPeerUserName,
                    peerModel: vm.peerModel
                )
                    .padding()
                
                Spacer()
                HStack {
//                    Spacer()
                    Button {
                        vm.writePeerData(isUpdate: isUpdate)
                        if !vm.showValidationError {
                            vm.updateParentVarData?(vm.peerModel, vm.peerImage)
                            presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        CommonViews.buttonLabel()
                    }
                    .padding(.horizontal)
                    
                }
                Spacer()
                
            }
        }
        //Need to utilise timers here
        .onChange(of: vm.peerModel.name) {
            vm.peerModel.initials = CommonFunctions.getInitialsFromName(
                name: vm.peerModel.name
            )
        }
        .alert("Error!", isPresented: $vm.showValidationError, actions: {
            Button("Ok") {
                
            }
        }, message: {
            Text(vm.validationErrorMessage)
        })
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
