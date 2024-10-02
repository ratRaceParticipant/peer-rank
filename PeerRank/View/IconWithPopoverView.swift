//
//  IconWithPopoverView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI

struct IconWithPopoverView: View {
    @State var isInfoPopTipShown: Bool = false
    @State var popOverText: InfoText = .baseRatingWeightageInfo
    var body: some View {
        Button(action: {
            isInfoPopTipShown.toggle()
        }, label: {
            Image(systemName: "info.circle")
                .font(.title2)
                
        })
        .popover(isPresented: $isInfoPopTipShown, attachmentAnchor: .point(.top), arrowEdge: .bottom) {
            Text(popOverText.rawValue)
                .lineLimit(5)
                .fixedSize(horizontal: false, vertical: true)
                .padding(8)
                .foregroundStyle(.primary)
                .presentationCompactAdaptation(.none)
                
        }
    }
}

#Preview {
    IconWithPopoverView(popOverText: InfoText.baseRatingWeightageInfo)
}
