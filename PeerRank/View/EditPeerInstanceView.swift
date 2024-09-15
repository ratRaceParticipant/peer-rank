//
//  EditPeerInstanceView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 14/09/24.
//

import SwiftUI

struct EditPeerInstanceView: View {
    
    var isUpdate: Bool
    @StateObject var vm: EditPeerInstanceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(
        peerModel: PeerModel,
        isUpdate: Bool = false,
        peerInstanceModel: PeerInstanceModel = PeerInstanceModel.emptyData,
        coreDataHandler: CoreDataHandler
    ) {
        
        self.isUpdate = isUpdate
        self._vm = StateObject(
            wrappedValue: EditPeerInstanceViewModel(
                peerModel: peerModel, 
                peerInstanceModel: peerInstanceModel,
                coreDataHandler: coreDataHandler
            )
        )
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading,spacing: 20.0) {
                
                DatePicker(
                    selection: $vm.peerInstanceModel.instanceDate, displayedComponents: [.date,.hourAndMinute]
                ) {
                    Text("Instance Date & Time")
                        .fontWeight(.bold)
                }
                
                .datePickerStyle(.compact)
                RatingView(
                    currentRating: $vm.instanceRating,
                    enableEditing: true
                )
                RatingWeightageView(
                    ratingWeightage: $vm.instanceRatingWeightage
                )
                Text("Description")
                    .fontWeight(.bold)
                CommonViews.textEditor(
                    bindingText: $vm.peerInstanceModel.instanceDescription
                )
                    
                HStack {
                    Spacer()
                    Button("Save") {
                        vm.writeToPeerInstance(isUpdate: isUpdate)
                        presentationMode.wrappedValue.dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                    .buttonBorderShape(.roundedRectangle)
                    
                }
                Spacer()
            }
            .padding()
        }
        .navigationTitle(isUpdate ? "Edit Instance" : "Add Instance")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        EditPeerInstanceView(
            peerModel: PeerModel.emptyData,
            coreDataHandler: CoreDataHandler()
        )
    }
}
