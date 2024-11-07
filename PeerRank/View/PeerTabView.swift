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
        Group {
            if vm.loadingStatus == .inprogress {
                ProgressView()
            } else {
                Group {
                    if !vm.peerModelData.isEmpty {
                        List(vm.peerModelData, id: \.peerId) { data in
                            NavigationLink {
                                PeerDetailView(
                                    peerDataModel: data,
                                    peerImage: data.peerImage,
                                    coreDataHandler: vm.coreDataHandler,
                                    localFileManager: vm.localFileManager,
                                    isDataDeleted: $vm.isSelectedDataDeleted,
                                    showDeleteAction: true
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
                        
                        
                        
                    } else {
                        DataUnavailableView(noDataType: .peerData)
                    }
                    
                }
                .searchable(text: $vm.searchText, prompt: "Search Peers")
                .onChange(of: vm.searchText) { _, searchText in
                    vm.fetchTask?.cancel()
                    vm.fetchTask = Task {
                        await vm.fetchAllData()
                    }
                }
            }
        }
        .navigationTitle("Peers")
        .toolbar(content: {
            ToolbarItem {
                navigationLinkForAddingPeer
            }
        })
        .task{
            await vm.fetchData(lastSelectedPeerModel: selectedPeerModel)
        }
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
