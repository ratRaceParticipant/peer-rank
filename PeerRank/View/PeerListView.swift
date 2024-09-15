//
//  PeerListView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI

struct PeerListView: View {
    @StateObject var vm: PeerListViewModel
    @State var selectedPeerModel: PeerModel?
    init(
        localFileManager: LocalFileManager,
        coreDataHandler: CoreDataHandler
    ){
        self._vm = StateObject(
            wrappedValue: PeerListViewModel(
                coreDataHandler: coreDataHandler,
                localFileManager: localFileManager
            )
        )
    }
    var body: some View {
        List(vm.peerModelData) { data in
            NavigationLink {
                PeerDetailView(
                    peerDataModel: data,
                    peerImage: data.peerImage,
                    coreDataHandler: vm.coreDataHandler,
                    localFileManager: vm.localFileManager
                )
                .onAppear{
                    selectedPeerModel = data
                }
            } label: {
                PeerListItemView(
                    localFileManager: vm.localFileManager, 
                    peerDataModel: data,
                    peerImage: data.peerImage
                )
            }
            
            
        }
        .task{
            await vm.fetchData(lastSelectedPeerModel: selectedPeerModel)
        }
        .listStyle(.inset)
        .navigationTitle("Peers")
        .toolbar(content: {
            ToolbarItem {
                NavigationLink {
                    EditPeerView(
                        localFileManager: vm.localFileManager,
                        coreDataHandler: vm.coreDataHandler
                    )
                } label: {
                    Image(systemName: "plus")
                }
            }
        })
    }
}

#Preview {
    NavigationStack {
        PeerListView(localFileManager: LocalFileManager(), coreDataHandler: CoreDataHandler())
    }
}
