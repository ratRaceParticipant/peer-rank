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
        Group {
            if !vm.peerInstanceModel.isEmpty {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Instances")
                            .fontWeight(.bold)
                        ScrollView {
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
                                        Text("\(CommonFunctions.formattedInstanceDate(data.instanceDate))")
                                            .foregroundColor(.accentColor)
                                            .font(.headline)
                                            .padding([.trailing,.vertical],4)
                                        Spacer()
                                        RatingView(
                                            currentRating: .constant(Float(data.instanceRating)),
                                            enableEditing: false,
                                            starFont: .subheadline
                                        )
                                    }
                                })
                                .id(UUID())
                                .tint(.clear)
                            }
                        }
                        Spacer()
                    }
                    
                    Spacer()
                }
            } else {
                DataUnavailableView(noDataType: .instanceData)
            }
        }
        
        .padding(.horizontal)
        .background{
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(
                    LinearGradient(gradient: Gradient(colors: [.clear, .secondary.opacity(0.1)]), startPoint: .top, endPoint: .bottom)
                )
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
