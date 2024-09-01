//
//  ContentView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm: ContentFileViewModel
    init(coreDataHandler: CoreDataHandler) {
        _vm = StateObject(wrappedValue: ContentFileViewModel(dataHandler: coreDataHandler))
    }
    var body: some View {
        VStack {
            Button("Save") {
                vm.peerModelData = PeerModel.sampleData
                vm.saveData()
            }
            Button("Fetch") {
                vm.fetchData()
            }
            Button("Delete") {
                vm.deleteAllData()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(coreDataHandler: CoreDataHandler())
}
