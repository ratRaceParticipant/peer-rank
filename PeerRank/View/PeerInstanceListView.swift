//
//  PeerInstanceListView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 14/09/24.
//

import SwiftUI

struct PeerInstanceListView: View {
    @StateObject var vm: PeerInstanceListViewModel
    
    init(
        peerModel: PeerModel,
        coreDataHandler: CoreDataHandler
    ){
        self._vm = StateObject(
            wrappedValue: PeerInstanceListViewModel(
                peerModel: peerModel,
                coreDataHandler: coreDataHandler
            )
        )
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Instances")
                    .fontWeight(.bold)
                ForEach(vm.peerInstanceModel, id: \.peerInstanceId){ data in
                    NavigationLink(
                        destination: {
                        EditPeerInstanceView(
                            peerModel: vm.peerModel,
                            isUpdate: true,
                            peerInstanceModel: data,
                            coreDataHandler: vm.coreDataHandler
                        )
                    }, label: {
                        HStack {
                            Text("\(vm.formattedDate(data.instanceDate))")
                                .foregroundColor(.accentColor)
                                .font(.title3)
                                .padding([.trailing,.vertical],4)
                            Spacer()
                            RatingView(
                                currentRating: .constant(Float(data.instanceRating)),
                                enableEditing: false,
                                starFont: .subheadline
                            )
                        }
                    })
                    .tint(.clear)
                }
            }
            
            Spacer()
        }
        .onAppear{
            vm.fetchPeerInstnaceData()
        }
        
    }
}

#Preview {
    PeerInstanceListView(
        peerModel: PeerModel.sampleData[0], coreDataHandler: CoreDataHandler()
    )
}
