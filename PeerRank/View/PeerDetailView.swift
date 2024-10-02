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
    
    init(
        peerDataModel: PeerModel = PeerModel.sampleData[0],
        peerImage: UIImage? = nil,
        coreDataHandler: CoreDataHandler,
        localFileManager: LocalFileManager
    ){
        self.peerDataModel = peerDataModel
        self.peerImage = peerImage
        self._vm = StateObject(
            wrappedValue: PeerDetailViewModel(
                coreDataHandler: coreDataHandler,
                localFileManager: localFileManager
            )
        )
    }
    
    var body: some View {
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
                VStack{
                    PeerInstancesChartView(coreDataHandler: vm.coreDataHandler, peerData: peerDataModel)
                }
                .padding([.horizontal,.bottom])
                PeerInstanceListView(
                    peerModel: peerDataModel,
                    coreDataHandler: vm.coreDataHandler
                )
                .padding([.horizontal,.top])
                Spacer()
            }
            .onAppear{
                vm.getAverageRatingToDisplay(peerModel: peerDataModel)
                peerDataModel = vm.getUpdatedPeerModelData(peerModel: peerDataModel)
            }
        }
        .ignoresSafeArea(.container,edges: .top)
        
    }
    
    var peerImageView: some View {
        Group{
            if let image = peerImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 400,height: 300)
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
                .font(.title2)
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
            EditPeerView(
                localFileManager: vm.localFileManager,
                isUpdate: true,
                peerModel: peerDataModel,
                coreDataHandler: vm.coreDataHandler,
                peerImage: peerImage){ _, peerImage  in
                   
                    self.peerImage = peerImage
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
        .padding([.horizontal,.top])
    }
}

#Preview {
    PeerDetailView(
        coreDataHandler: CoreDataHandler(), localFileManager: LocalFileManager()
    )
}
