//
//  HomeView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var vm: HomeViewModel
    init(
        coreDataHandler: CoreDataHandler,
        localFileManager: LocalFileManager
    ){
        self._vm = StateObject(
            wrappedValue: HomeViewModel(
                coreDataHandler: coreDataHandler,
                localFileManager: localFileManager
            )
        )
    }
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if vm.peerDataModel.count >= 3 {
                    HStack(spacing: 0) {
                        PeerBannerView(coreDataHandler: vm.coreDataHandler)
                        PeerBannerView(coreDataHandler: vm.coreDataHandler,fetchTopRatedPeers: false)
                    }
                } else {
                    DataUnavailableView(noDataType: .kpiData)
                }
            }
            .onAppear{
                vm.fetchPeerData()
            }
            Text("Recent Peers")
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.leading)
            PeerListView(
                coreDataHandler: vm.coreDataHandler,
                localFileManager: vm.localFileManager
            )
            Spacer()
        }
        .background{
            Color.clear
        }
        .navigationTitle("Peer Rank")
    }
}

#Preview {
    NavigationStack {
        HomeView(
            coreDataHandler: CoreDataHandler(),
            localFileManager: LocalFileManager()
        )
    }
}
