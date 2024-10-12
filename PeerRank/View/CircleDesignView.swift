//
//  CircleDesignView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 12/10/24.
//

import SwiftUI

struct CircleDesignView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(.accent)
                .frame(width: 500,height: 500)
            Circle()
                .frame(width: 400,height: 400)
                .foregroundStyle(.clear)
            Circle()
                .frame(width: 300,height: 300)
                .foregroundStyle(.accent)
        }
        .background(Color.clear)
    }
}

#Preview {
    CircleDesignView()
}
