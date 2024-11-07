//
//  PeerSelectorView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/10/24.
//

import SwiftUI

struct PeerSelectorView: View {
    @StateObject var vm: PeerSelectorViewModel
    @Binding var selectedPeerUserName: String?
    init(
        
        selectedPeerUserName: Binding<String?> = .constant("himanshu"),
        peerModel: PeerModel
    ){
        self._vm = StateObject(wrappedValue: PeerSelectorViewModel(
            peerModel: peerModel
        ))
        self._selectedPeerUserName = selectedPeerUserName
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Link Peer")
                .fontWeight(.bold)
            if(
                vm.currentUserConfig?.userName?.isEmpty ?? true ||
                vm.currentUserConfig?.iCloudConnectionStatus == .notConnected
            ) {
                WarningTextView(warningType: .peerLinkingNotAvailable,showWarningText: false)
            } else {
                Group{
                    if selectedPeerUserName != nil, selectedPeerUserName != "" {
                        HStack(alignment: .center){
                            Text("\(selectedPeerUserName ?? "")")
                                .foregroundStyle(Color(.secondaryLabel))
                            Button {
                                withAnimation {
                                    selectedPeerUserName = nil
                                }
                            } label: {
                                Image(systemName: "multiply")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                            
                        }
                    } else {
                        HStack{
                            TextField("Text", text: $vm.searchText, prompt: Text("Search Username"))
                            Spacer()
                            Button {
                                withAnimation {
                                    vm.peerLinkingStatus = .inprogress
                                }
                                Task {
                                    let userName = await vm.fetchPeersToSelect()
                                    selectedPeerUserName = userName
                                    withAnimation {
                                        vm.peerLinkingStatus = .notStarted
                                    }
                                }
                            } label: {
                                if vm.peerLinkingStatus == .notStarted {
                                    Text("Search")
                                } else {
                                    ProgressView()
                                }
                            }
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                if !vm.peerLinkingErrorMessage.isEmpty {
                    Text(vm.peerLinkingErrorMessage)
                        .font(.caption)
                        .foregroundStyle(Color.red)
                }
            }
        }
    }
}


#Preview {
    PeerSelectorView(peerModel: PeerModel.emptyData)
        .padding()
}
