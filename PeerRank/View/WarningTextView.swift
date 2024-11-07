//
//  WarningTextView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/11/24.
//

import SwiftUI

struct WarningTextView: View {
    var warningType: WarningType = .peerLinkingNotAvailable
    var showWarningText: Bool = true
    var body: some View {
        Text("\(showWarningText ? "Warning: " : "")\(warningType.rawValue)")
            .font(.footnote)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    WarningTextView()
        .padding()
}
