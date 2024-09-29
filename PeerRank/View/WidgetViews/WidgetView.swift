//
//  WidgetView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import SwiftUI
import WidgetKit
struct WidgetView: View {
    var peerDataModel: [PeerModel]
    var fetchTopRatedPeers: Bool = true
    var body: some View {
        Group {
            VStack(spacing: 5) {
                Spacer()
                ForEach(peerDataModel.indices, id: \.self) { index in
                    let starSize: CGFloat = 30 - (CGFloat(index) * 2)
                    HStack {
                        ZStack {
                            Image(systemName: "star.fill")
                                
                                .font(
                                    .system(
                                        size: starSize
                                            
                                    )
                                )
                                .foregroundStyle(.yellow)
                                
                            Text("\(peerDataModel[index].averageRating, specifier: "%.1f")")
                                
                                .font(
                                    .system(
//                                            size: 10
                                        size: 15 - (CGFloat(index) * 2)
                                    )
                                )
                                .foregroundStyle(.black)
                        }
                            .padding(.horizontal, CGFloat(index) * 1)
                        Text("\(peerDataModel[index].name)")
                            .lineLimit(2)
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
                Spacer()
                
            }
            
        }
    }
}

#Preview(body: {
    WidgetView(peerDataModel: PeerModel.sampleData)
        
})
