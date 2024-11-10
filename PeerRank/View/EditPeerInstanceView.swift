//
//  EditPeerInstanceView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 14/09/24.
//

import SwiftUI


extension Binding where Value == Bool {
    init(value: Binding<ValidationStatus>) {
        self.init {
            return value.wrappedValue != ValidationStatus.noError
        } set: { newValue in
            if !newValue {
                value.wrappedValue = ValidationStatus.noError
            }
        }
    }
}

struct EditPeerInstanceView: View {
    
    var isUpdate: Bool
    @StateObject var vm: EditPeerInstanceViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(
        peerModel: PeerModel,
        isUpdate: Bool = false,
        peerInstanceModel: PeerInstanceModel = PeerInstanceModel.emptyData,
        coreDataHandler: CoreDataHandler,
        ratedPeerModel: RatedPeerModel?
    ) {
        
        self.isUpdate = isUpdate
        self._vm = StateObject(
            wrappedValue: EditPeerInstanceViewModel(
                peerModel: peerModel, 
                peerInstanceModel: peerInstanceModel,
                coreDataHandler: coreDataHandler,
                ratedPeerModel: ratedPeerModel
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
//                    Spacer()
                    Button {
                        Task {
                            await vm.writeToPeerInstance(isUpdate: isUpdate)
                            if vm.validationStatus == .noError {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    } label: {
                        CommonViews.buttonLabel(loadingStatus: vm.dataWriteStatus)
                    }
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
                Task {
                    await vm.deleteData()
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }, message: {
            Text("This action cannot be undone.")
        })
        .alert("Error!", isPresented: Binding(value: $vm.validationStatus), actions: {
            Button("Ok") {
                
            }
        }, message: {
            Text(vm.validationStatus.getValidationError())
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
            isUpdate: true, coreDataHandler: CoreDataHandler(),
            ratedPeerModel: nil
        )
    }
}
