//
//  PeerInstanceListView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 14/09/24.
//

import SwiftUI

struct PeerInstanceListView: View {
    @StateObject var vm: PeerInstanceListViewModel
    @ObservedObject var sharedData: SharedData
    init(
        peerModel: PeerModel,
        coreDataHandler: CoreDataHandler,
        ratedPeerModel: RatedPeerModel? = nil,
        sharedData: SharedData = SharedData()
    ){
        self._vm = StateObject(
            wrappedValue: PeerInstanceListViewModel(
                peerModel: peerModel,
                coreDataHandler: coreDataHandler,
                ratedPeerModel: ratedPeerModel
            )
        )
        self._sharedData = ObservedObject(wrappedValue: sharedData)
    }
    
    var body: some View {
        Group {
            if !vm.peerInstanceModel.isEmpty {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Instances")
                            .fontWeight(.bold)
                        ScrollView {
                            instanceList
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
    var instanceList: some View {
        ForEach(vm.peerInstanceModel, id: \.peerInstanceId){ data in
            NavigationLink(
                destination: {
                    EditPeerInstanceView(
                        peerModel: vm.peerModel,
                        isUpdate: true,
                        peerInstanceModel: data,
                        coreDataHandler: vm.coreDataHandler,
                        ratedPeerModel: vm.ratedPeerModel,
                        sharedData: sharedData
                    )
            }, label: {
                getLabelView(data: data)
            })
            .id(UUID())
            .tint(.clear)
        }
    }
    func getLabelView(data: PeerInstanceModel) -> some View {
        return HStack {
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
    }
}

#Preview {
    PeerInstanceListView(
        peerModel: PeerModel.sampleData[0], coreDataHandler: CoreDataHandler()
    )
}
