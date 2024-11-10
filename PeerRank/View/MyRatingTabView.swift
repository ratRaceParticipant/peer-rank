//
//  MyRatingTabView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/11/24.
//

import SwiftUI

struct MyRatingTabView: View {
    @StateObject var vm = MyRatingTabViewModel()
    var body: some View {
        Group {
            if vm.loadingStatus == .inprogress {
                ProgressView()
            } else {
                if vm.currentUserConfig?.iCloudConnectionStatus == .notConnected || vm.currentUserConfig?.userName?.isEmpty ?? true {
                    DataUnavailableView(noDataType: .iCloudConnection)
                } else {
                    if vm.ratedPeerData.isEmpty {
                        DataUnavailableView(noDataType: .ratedPeerData)
                    } else {
                        List(vm.ratedPeerData, id: \.peerUserName){ data in
                            getLabel(data: data)
                        }
                    }
                }
            }
        }
        .task {
            
            await vm.fetchData()
            vm.loadingStatus = .complete
        }
        .navigationTitle("My Ratings")
    }
    func getLabel(data: RatedPeerModel) -> some View {
        VStack(alignment: .leading) {
            Text("By: **\(data.peerUserName)**")
            HStack {
                RatingView(
                    currentRating: .constant(data.peerToRateRating),
                    enableEditing: false
                )
                Text("\(data.peerToRateRating, specifier: "%.2f")")
                    .fontWeight(.bold)
                Spacer()
            }
        }
    }
}

#Preview {
    MyRatingTabView()
}
