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
            wrappedValue: SettingViewModel(
                coreDataHandler: coreDataHandler
            )
        )
    }
    
    var body: some View {
        ZStack {
            List {
                Section {
                    iCloudAccountStatusView
                } header: {
                    Text("iCloud Status")
                }
                Section {
                    if let userName = vm.userConfigModel?.userName{
                        HStack {
                            Text("username: **\(userName)**")
                            Spacer()
                            Button("Edit") {
                                vm.showRegisterSheet = true
                                vm.updateUserConfigData = true
                            }
                            .disabled(vm.userConfigModel?.iCloudConnectionStatus == .notConnected)
                        }
                    } else {
                        Button("Register") {
                            vm.showRegisterSheet = true
                            vm.updateUserConfigData = false
                        }
                        .disabled(vm.userConfigModel?.iCloudConnectionStatus == .notConnected)
                    }
                } header: {
                    Text("Account Details")
                } footer: {
                    Text("By Registering your account other people can link their peer to you.")
                }

                Section {
                    importButton
                    exportButton
                } header: {
                    Text("Data Managment")
                } footer: {
                    VStack(alignment: .leading) {
                        Text("Warning: As of now searching peers takes huge computing resources.")
                        Text(
                            "\nCharts for Individual Peers used from: [AppPear Github](https://github.com/AppPear/ChartView).\n")
                        Text("Peer Image Downsampling Code used from: [Swift Senpai](https://swiftsenpai.com/development/reduce-uiimage-memory-footprint/)\n")
                    
                        Text("App Source Code and documentaion: [Peer Rank](https://github.com/ratRaceParticipant/peer-rank)\n")
                    }
                }
            }
            PopupView(loadingStatus: vm.importingStatus)
                .scaleEffect(vm.importingStatus == .notStarted ? 0 : 1)
            
        }
        .sheet(isPresented: $vm.showRegisterSheet, onDismiss: {
            vm.updateUserConfigData = false
            Task {
                await vm.refreshUserConfig()
            }
        }, content: {
            NavigationStack {
                RegisterAccountView(
                    userConfigModel: vm.userConfigModel ?? UserConfigModel(),
                    isUpdate: vm.updateUserConfigData
                )
            }
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.visible)
        })
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
        .task {
            
            await vm.refreshUserConfig()
        }
        .navigationTitle("Settings")
    }
    var iCloudAccountStatusView: some View {
        HStack {
            Image(systemName: "circle.fill")
                .font(.subheadline)
                .foregroundStyle(
                    vm.userConfigModel?.iCloudConnectionStatus == .connected ? .green : .red
                )
            Text("\(vm.userConfigModel?.iCloudConnectionStatus.rawValue ?? iCloudConnectionStatus.notConnected.rawValue)")
            Spacer()
            Button {
                Task {
                    await vm.refreshUserConfig()
                }
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 22))
            }

        }
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
            vm.isExporting = true
            vm.exportDataToJsonFile()
            vm.isExporting = false
           
        } label: {
            if vm.isExporting {
                ProgressView()
            } else {
                Text("Export Data")
            }
        }
        
    }
}

#Preview {
    SettingsView(coreDataHandler: CoreDataHandler())
}
