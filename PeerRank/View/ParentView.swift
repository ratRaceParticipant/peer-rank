//
//  ParentView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import SwiftUI

struct ParentView: View {
    var localFileManager: LocalFileManager
    var coreDataHandler: CoreDataHandler
    var cloudKitHandler: CloudKitHandler
    @StateObject var vm: ParentViewModel
    @State var isDataNull: Bool = false
    
    init(
        localFileManager: LocalFileManager = LocalFileManager(),
        coreDataHandler: CoreDataHandler = CoreDataHandler(),
        cloudKitHandler: CloudKitHandler = CloudKitHandler()
    ){
        self.localFileManager = localFileManager
        self.coreDataHandler = coreDataHandler
        self._vm = StateObject(
            wrappedValue: ParentViewModel(
                coreDataHandler: coreDataHandler,
                localFileManager: localFileManager,
                cloudKitHandler: cloudKitHandler
            )
        )
        self.cloudKitHandler = cloudKitHandler
    }
    var body: some View {
        Group {
            if isDataNull {
                NavigationStack {
                    AddPeerView(
                        localFileManager: localFileManager,
                        coreDataHandler: coreDataHandler,
                        isDataNull: $isDataNull
                    )
                }
            } else {
                TabView {
                    ZStack {
//                        CircleDesignView()
                        NavigationStack {
                            HomeView(
                                coreDataHandler: coreDataHandler,
                                localFileManager: localFileManager
                            )
                        }
                        .background(Color.clear)
                        
                    }
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    NavigationStack {
                        PeerTabView(
                            localFileManager: localFileManager,
                            coreDataHandler: coreDataHandler
                        )
                    }
                    .tabItem {
                        Label("Peers", systemImage: "person")
                    }
                    NavigationStack {
                        SettingsView(
                            coreDataHandler: coreDataHandler,
                            cloudKitHandler: cloudKitHandler
                        )
                    }
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
                }
            }
        }
        .task {
            await vm.mapiCloudUserDataWithUserConfig()
        }
        .onAppear{
            isDataNull = vm.isDataNull()
        }
    }
}

#Preview {
    ParentView()
}
