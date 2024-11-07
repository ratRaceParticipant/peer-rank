//
//  PeerDetailView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import SwiftUI

struct PeerDetailView: View {
    @State var peerDataModel: PeerModel
    @StateObject var vm: PeerDetailViewModel
    @State var peerImage: UIImage?
    @Binding var isDataDeleted: Bool
    @Environment(\.presentationMode) var presentationMode
    init(
        peerDataModel: PeerModel = PeerModel.sampleData[0],
        peerImage: UIImage? = nil,
        coreDataHandler: CoreDataHandler,
        localFileManager: LocalFileManager,
        isDataDeleted: Binding<Bool> = .constant(false),
        showDeleteAction: Bool = false
    ){
        self.peerDataModel = peerDataModel
        self.peerImage = peerImage
        self._vm = StateObject(
            wrappedValue: PeerDetailViewModel(
                coreDataHandler: coreDataHandler,
                localFileManager: localFileManager,
                showDeleteAction: showDeleteAction
            )
        )
        self._isDataDeleted = isDataDeleted
    }
    
    var body: some View {
        Group {
            if vm.isUnlocked {
                ScrollView {
                    VStack(alignment: .leading) {
                        peerImageView
                        HStack {
                            nameAndRatingView
                            Spacer()
                            navigationLinkToEditView
                        }
                        .padding(.horizontal)
                        navigationLinkToAddInstanceView
                        PeerInstanceListView(
                            peerModel: peerDataModel,
                            coreDataHandler: vm.coreDataHandler
                        )
                        PeerInstancesChartView(coreDataHandler: vm.coreDataHandler, peerData: peerDataModel)
                            .padding(.horizontal)
                        Spacer()
                    }
                    
                    .alert("Are you sure you want to delete?", isPresented: $vm.showDeleteConfirmation, actions: {
                        Button("Yes", role: .destructive){
                            vm.deleteData(peerDataModel: peerDataModel)
                            isDataDeleted = true
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, message: {
                        Text("This action cannot be undone.")
                    })
                    .toolbar(content: {
                        if vm.showDeleteAction {
                            ToolbarItem(placement: .topBarTrailing) {
                                deleteIcon
                            }
                        }
                    })
                }
                .ignoresSafeArea(.container,edges: .top)
            } else {
                DataUnavailableView(noDataType: .peerDetailDataAuthenticationFailed)
            }
        }
        
        .task {
            vm.ratedPeerModel = await vm.setRatedPeerData(peerModel: peerDataModel)
        }
        .onAppear{
//            Task {
//                let data = await vm.setRatedPeerData(peerModel: peerDataModel)
//                
//                vm.ratedPeerModel = data
//                
//            }
            vm.authenticate(peerDataModel: peerDataModel)
            vm.getAverageRatingToDisplay(peerModel: peerDataModel)
            peerDataModel = vm.getUpdatedPeerModelData(peerModel: peerDataModel)
        }
        
        
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
    
    var peerImageView: some View {
        Group{
            if let image = peerImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    
                    .frame(width: 400,height: 300)
                    .clipped()
                    .overlay{
                        Color.black.opacity(0.3)
                    }
            } else {
                Rectangle()
                    .frame(width: 400,height: 300)
                    .foregroundStyle(.tertiary)
                    
                    .overlay {
                        Text(peerDataModel.initials)
                            .font(.system(size: 150))
                    }
                    .foregroundStyle(PeerType(rawValue: peerDataModel.type)?.getBgColor() ?? .clear)
            }
        }
        .padding(.bottom)
    }
    var nameAndRatingView: some View {
        VStack(alignment: .leading){
            Text(peerDataModel.name)
                
                .fontWeight(.bold)
                
           
            HStack {
                RatingView(
                    currentRating: .constant(peerDataModel.averageRating),
                    enableEditing: false,
                    starFont: .title3
                )
                Text("\(vm.averageRating, specifier: "%.2f")")
                    .fontWeight(.bold)
                IconWithPopoverView(isInfoPopTipShown: false,popOverText: .averageRating)
            }
        }
    }
    var navigationLinkToEditView: some View {
        NavigationLink {
            if let _ = vm.ratedPeerModel {
                EditPeerView(
                    localFileManager: vm.localFileManager,
                    isUpdate: true,
                    peerModel: peerDataModel,
                    coreDataHandler: vm.coreDataHandler,
                    peerImage: peerImage,
                    ratedPeerModel: vm.ratedPeerModel){ _, peerImage  in
                       
                        self.peerImage = peerImage
                    }
            } else {
                ProgressView()
            }
                
        } label: {
            Label(
                title: {
                    Text("Edit")
                    .font(.title3)
                },
                icon: {
                    Image(systemName: "square.and.pencil")
                }
            )
            
        }
        .id(UUID())
    }
    var navigationLinkToAddInstanceView: some View {
        NavigationLink {
            EditPeerInstanceView(
                peerModel: peerDataModel,
                isUpdate: false,
                coreDataHandler: vm.coreDataHandler
            )
        } label: {
            Label(
                title: { Text("Add Instance") },
                icon: { Image(systemName: "plus") }
            )
            
        }
        .id(UUID())
        .padding()
    }
}

#Preview {
    NavigationStack {
        PeerDetailView(
            coreDataHandler: CoreDataHandler(), localFileManager: LocalFileManager(), isDataDeleted: .constant(false)
            
        )
    }
}
