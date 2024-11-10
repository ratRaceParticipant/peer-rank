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
                Spacer()
                
                HStack(spacing: 10) {
                    ForEach(0..<3) { index in
                        singleRatingView(index: index)
                    }
                }
                
            }
            .foregroundStyle(.white)
            .padding()
            .background(
                Color.accentColor.clipShape(RoundedRectangle(cornerRadius: 10))
            )
            .padding(.bottom)
            
        }
        
        .onAppear{
            vm.fetchBannerData(fetchTopRatedPeers: fetchTopRatedPeers)
            DispatchQueue.main.async {
                withAnimation(.bouncy.delay(0.5)) {
                    vm.hasScreenAppeared = true
                }
            }
            
        }
    }
    func singleRatingView(index: Int = 0) -> some View{
        VStack(alignment: .center){
            Spacer()
            Text(vm.peerDataModel[index].initials)
            Text(vm.peerDataModel[index].name)
                .lineLimit(1)
                .font(.caption)
            HStack{
                Spacer()
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                Text("\(vm.peerDataModel[index].averageRating, specifier: "%.2f")")
                
                Spacer()
            }
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.ultraThinMaterial)
                    .frame(height: vm.hasScreenAppeared ? CGFloat(UIScreen.main.bounds.height * 0.3 - CGFloat((index * 50))) : 0)
                Text("\(index+1)")
            }
        }
        .frame(height: 350)
    }
}

#Preview {
    PeerBannerView(
        coreDataHandler: CoreDataHandler()
    )
}
