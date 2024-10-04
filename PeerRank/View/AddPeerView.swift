//
//  AddPeerView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 03/10/24.
//

import SwiftUI

struct AddPeerView: View {
    @State var isAnimate: Bool = false
    var localFileManager: LocalFileManager
    var coreDataHandler: CoreDataHandler
    @Binding var isDataNull: Bool
    var body: some View {
        VStack {
            Spacer()
            DataUnavailableView(noDataType: .peerData)
//                .background(Color.red)
                .frame(height: 200)
            NavigationLink {
                EditPeerView(
                    localFileManager: localFileManager,
                    isUpdate: false,
                    coreDataHandler: coreDataHandler) { _, _ in
                        isDataNull = false
                    }
            } label: {
                addItemButtonLabel
            }

            Spacer()
        }
        .onAppear{
            isAnimate = true
        }
    }
    var addItemButtonLabel: some View {
        Text("Add Peers")
            .foregroundColor(.white)
            .background(
                Color.accentColor
                    .cornerRadius(10)
                    .frame(
                        width:isAnimate ? 300 : 280,
                        height:isAnimate ? 80 : 60
                    )
//                        .background(Color.green)
                    .shadow(
                        color: Color.accentColor.opacity(0.5),
                        radius: 10,
                        x: 0,y: isAnimate ? 15 : 10
                    )
                    .animation(
                        Animation.linear(duration: 1.5).repeatForever(),
                        value: isAnimate
                    )
            )
            .padding(.vertical,30)
    }
}

#Preview {
    AddPeerView(
        localFileManager: LocalFileManager(), coreDataHandler: CoreDataHandler(),
        isDataNull: .constant(false)
    )
}
