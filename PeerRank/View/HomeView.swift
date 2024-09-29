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
        coreDataHandler: CoreDataHandler
    ){
        self._vm = StateObject(
            wrappedValue: HomeViewModel(
                coreDataHandler: coreDataHandler
            )
        )
    }
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                
                PeerBannerView(coreDataHandler: vm.coreDataHandler)
                PeerBannerView(coreDataHandler: vm.coreDataHandler,fetchTopRatedPeers: false)
            }
            
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
        HomeView(coreDataHandler: CoreDataHandler())
    }
}
