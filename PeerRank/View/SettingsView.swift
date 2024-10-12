//
//  SettingsView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 12/10/24.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var vm: SettingViewModel
    
    init(
        coreDataHandler: CoreDataHandler
    ) {
        self._vm = StateObject(
            wrappedValue: SettingViewModel(coreDataHandler: coreDataHandler)
        )
    }
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    Section {
                        importButton
                        exportButton
                    } header: {
                        Text("Data Managment")
                    } footer: {
                        VStack(alignment: .leading) {
                            Text("Warning: As of now searching peers takes huge computing resources.\n")
                            Text(
                                "\nCharts for Individual Peers used from: [AppPear Github](https://github.com/AppPear/ChartView).\n")
                            Text("Peer Image Downsampling Code used from: [Swift Senpai](https://swiftsenpai.com/development/reduce-uiimage-memory-footprint/)\n")
                        
                            Text("App Source Code and documentaion: [Peer Rank](https://github.com/ratRaceParticipant/peer-rank)\n")
                            
//                            Text("App made by Himanshu Karamchandani")
                            
                        }
                    }

                }
                
            }
            PopupView(loadingStatus: vm.importingStatus)
                .scaleEffect(vm.importingStatus == .notStarted ? 0 : 1)
        }
        .sheet(isPresented: $vm.showShareSheet, onDismiss: {
            vm.deleteTempFile()
        }, content: {
            CustomShareSheetView(url: $vm.exportUrl)
        })
        .fileImporter(
            isPresented: $vm.presentFilePicker,
            allowedContentTypes: [.json],
            allowsMultipleSelection: false,
            onCompletion: { result in
                withAnimation(.bouncy(duration: 0.2)) {
                    vm.importingStatus = .inprogress
                }
                vm.getUrlForJsonToImport(result: result)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    withAnimation(.bouncy(duration: 0.2)) {
                        vm.importingStatus = .notStarted
                    }
                }
            }
        )
       
        .navigationTitle("Settings")
    }
    var importButton: some View {
        Button {
            vm.presentFilePicker = true
        } label: {
            Text("Import Data")
        }
       
    }
    var exportButton: some View {
        Button {
            vm.exportDataToJsonFile()
        } label: {
            Text("Export Data")
        }
        
    }
}

#Preview {
    SettingsView(coreDataHandler: CoreDataHandler())
}
