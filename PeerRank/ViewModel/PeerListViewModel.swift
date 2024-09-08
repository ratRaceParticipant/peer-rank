//
//  PeerListViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import CoreData

class PeerListViewModel: ObservableObject {
    
    @Published var peerModelData: [PeerModel] = []
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager) {
        
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
        
    }
    
    func fetchData(){
        let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
        do {
            var data: [PeerModel] = []
            let peerEntityData =  try coreDataHandler.viewContext.fetch(request)
            for entityData in peerEntityData {
                data.append(
                    PeerModel.mapEntityToModel(
                    peerEntity: entityData,
                    context: coreDataHandler.viewContext
                    )
                )
            }
            peerModelData = data
            
        } catch {
            print("Error fetching data")
        }
    }
}
