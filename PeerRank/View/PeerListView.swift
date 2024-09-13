//
//  PeerListView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI

struct PeerListView: View {
    @StateObject var vm: PeerListViewModel
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
            let peerImage: UIImage? = vm.getImage(peerDataModel: data)
            NavigationLink {
                EditPeerView(
                    localFileManager: vm.localFileManager,
                    isUpdate: true,
                    peerModel: data,
                    coreDataHandler: vm.coreDataHandler,
                    peerImage: peerImage
                )
            } label: {
                PeerListItemView(
                    localFileManager: vm.localFileManager, 
                    peerDataModel: data,
                    peerImage: peerImage
                )
            }
        }
        .onAppear{
            vm.fetchData()
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
