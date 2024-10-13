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
                instanceDateSelectorView
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
        .toolbar(content: {
            if isUpdate {
                ToolbarItem {
                    deleteIcon
                }
            }
        })
        .alert("Are you sure you want to delete?", isPresented: $vm.showDeleteConfirmation, actions: {
            Button("Yes", role: .destructive){
                vm.deleteData()
                presentationMode.wrappedValue.dismiss()
            }
        }, message: {
            Text("This action cannot be undone.")
        })
        .navigationTitle(isUpdate ? "Edit Instance" : "Add Instance")
        .navigationBarTitleDisplayMode(.inline)
    }
    var deleteIcon: some View {
        Button {
            vm.showDeleteConfirmation = true
        } label: {
            Label(
                title: { Text("Delete") },
                icon: { Image(systemName: "trash") }
            )
            
        }
        .tint(.red)
    }
    var instanceDateSelectorView: some View {
        DatePicker(
            selection: $vm.peerInstanceModel.instanceDate,
            in: ...Date(),
            displayedComponents: [.date,.hourAndMinute]
        ) {
            Text("Instance Date & Time")
                .fontWeight(.bold)
        }
        
        .datePickerStyle(.compact)
    }
}

#Preview {
    NavigationStack {
        EditPeerInstanceView(
            peerModel: PeerModel.emptyData,
            isUpdate: true, coreDataHandler: CoreDataHandler()
        )
    }
}
