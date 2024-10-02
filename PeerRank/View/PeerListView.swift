//
//  PeerListView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 29/09/24.
//

import SwiftUI

struct PeerListView: View {
    @StateObject var vm: PeerListViewModel
    
    init(
        coreDataHandler: CoreDataHandler,
        localFileManager: LocalFileManager,
        peerModelData: [PeerModel] = [],
        fetchFromCoreData: Bool = true
    ){
        self._vm = StateObject(
            wrappedValue: PeerListViewModel(
                coreDataHandler: coreDataHandler,
                localFileManager: localFileManager,
                peerModelData: peerModelData,
                fetchFromCoreData: fetchFromCoreData
            )
        )
    }
    
    var body: some View {
        List(vm.peerModelData, id: \.peerId) { data in
            NavigationLink {
                PeerDetailView(
                    peerDataModel: data,
                    peerImage: data.peerImage,
                    coreDataHandler: vm.coreDataHandler,
                    localFileManager: vm.localFileManager
                )
            } label: {
                PeerListItemView(
                    localFileManager: vm.localFileManager,
                    peerDataModel: data,
                    peerImage: data.peerImage
                )
            }
        }
        .onAppear{
            vm.fetchData()
        }
        
        .listStyle(.inset)
    }
}

#Preview {
    PeerListView(
        coreDataHandler: CoreDataHandler(), localFileManager: LocalFileManager()
    )
}
