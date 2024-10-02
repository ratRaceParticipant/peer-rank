//
//  DataUnavailableView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 02/10/24.
//

import SwiftUI

struct DataUnavailableView: View {
    var noDataType: DataUnavailable
    var dictionary: [String:String]
    init(noDataType: DataUnavailable = .peerData) {
        self.noDataType = noDataType
        self.dictionary = noDataType.getDataUnavailableMap()
    }
    var body: some View {
        ContentUnavailableView(
            dictionary["title"] ?? "",
            systemImage:dictionary["icon"] ?? "",
            description:Text(dictionary["description"] ?? "")
        )
        
    }
}

#Preview {
    DataUnavailableView()
}
