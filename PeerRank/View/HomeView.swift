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
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
    }
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                
                if vm.peerDataModel.count >= 3 {
                    PeerBannerView(coreDataHandler: vm.coreDataHandler)
                        .frame(height: UIScreen.main.bounds.height * 0.55)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
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
        .ignoresSafeArea(.container,edges: .top)
        .background{
            Color.clear
        }
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Text("Leaderboard")
                    .fontWeight(.bold)
                    .foregroundColor(.white) // Set your desired color here
                    .font(.headline) // Customize font if desired
                }
        }
       
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
