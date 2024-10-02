//
//  PeerTabView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI

struct PeerTabView: View {
    @StateObject var vm: PeerTabViewModel
    @State var selectedPeerModel: PeerModel?
    init(
        localFileManager: LocalFileManager,
        coreDataHandler: CoreDataHandler
    ){
        self._vm = StateObject(
            wrappedValue: PeerTabViewModel(
                coreDataHandler: coreDataHandler,
                localFileManager: localFileManager
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
                navigationLinkForAddingPeer
            }
        })
    }
    var navigationLinkForAddingPeer: some View {
        NavigationLink {
            EditPeerView(
                localFileManager: vm.localFileManager,
                coreDataHandler: vm.coreDataHandler) { peerDataModel, uiImage in
                    vm.peerModelData.append(peerDataModel)
                }
        } label: {
            Image(systemName: "plus")
        }
    }
}

#Preview {
    NavigationStack {
        PeerTabView(localFileManager: LocalFileManager(), coreDataHandler: CoreDataHandler())
    }
}
