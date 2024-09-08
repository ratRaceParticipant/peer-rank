//
//  PeerDetailView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import SwiftUI

struct PeerDetailView: View {
    var peerDataModel: PeerModel = PeerModel.sampleData[0]
    @StateObject var vm = PeerDetailViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                
                if let image = vm.peerImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100,height: 100)
                        
                } else {
                    Rectangle()
                        .frame(width: 400,height: 300)
                        .foregroundStyle(PeerType(rawValue: peerDataModel.type)?.getBgColor() ?? .clear)
                        .overlay {
                            Text(peerDataModel.initials)
                                .foregroundStyle(.secondary)
                                .font(.system(size: 150))
                        }
                }
            }
            .ignoresSafeArea()
            .overlay {
                LinearGradient(colors: [
                    .clear,
                    .clear,
                    .clear,
                    .white.opacity(0.1),
                    .white.opacity(0.6),
                    .white.opacity(1),
                    .white
                ], startPoint: .top, endPoint: .bottom)
                .opacity(1)
            }
            Group {
                Text(peerDataModel.name)
                    
                    .font(.title)
                    .fontWeight(.bold)
                    
               
                HStack {
                    RatingView(currentRating: .constant(peerDataModel.averageRating),enableEditing: false)
                    IconWithPopoverView(isInfoPopTipShown: false,popOverText: .averageRating)
                }
                    
            }
            .padding(.leading)
            .offset(y: -80)
            Spacer()
        }
    }
}

#Preview {
    PeerDetailView()
}
