//
//  PeerBannerView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import SwiftUI

struct PeerBannerView: View {
    @StateObject var vm: PeerBannerViewModel
    var fetchTopRatedPeers: Bool
//    var bgColor: any ShapeStyle
    init(
        coreDataHandler: CoreDataHandler,
        fetchTopRatedPeers: Bool = true
    ){
        self._vm = StateObject(
            wrappedValue: PeerBannerViewModel(
                coreDataHandler: coreDataHandler
            )
        )
        self.fetchTopRatedPeers = fetchTopRatedPeers
        
    }
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                Text(fetchTopRatedPeers ? "Top Rated Peers" : "Worst Rated Peers")
                    .font(.subheadline)
                    .fontWeight(.bold)
                VStack(spacing: 0) {
                    
                    ForEach(vm.peerDataModel.indices, id: \.self) { index in
                        let starSize: CGFloat = 35 - (CGFloat(index) * 1.5)
                        HStack {
                            ZStack {
                                Image(systemName: "star.fill")
                                    
                                    .font(
                                        .system(
                                            size: starSize
                                                
                                        )
                                    )
                                    .foregroundStyle(.yellow)
                                    
                                Text("\(vm.peerDataModel[index].averageRating, specifier: "%.1f")")
                                    
                                    .font(
                                        .system(
//                                            size: 10
                                            size: 15 - (CGFloat(index) * 1)
                                        )
                                    )
                                    .foregroundStyle(.black)
                            }
                            .padding(.horizontal, CGFloat(index) * 1)
                            Text("\(vm.peerDataModel[index].name)")
                                .fontWeight(.semibold)
                                .font(
                                    .system(
//                                        size: 10
                                        size: 15 - (CGFloat(index) * 1)
                                    )
                                )
                            Spacer()
                        }
                    }
                    
                }
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 25)
                        .foregroundColor(
                            fetchTopRatedPeers ? .green : .pink
                        )
                        
                }
            }
            .padding()
        }
        .onAppear{
            vm.fetchBannerData(fetchTopRatedPeers: fetchTopRatedPeers)
        }
    }
}

#Preview {
    HStack(spacing: 0) {
        PeerBannerView(
            coreDataHandler: CoreDataHandler()
        )
        PeerBannerView(
            coreDataHandler: CoreDataHandler(),
            fetchTopRatedPeers: false
        )
    }
}
