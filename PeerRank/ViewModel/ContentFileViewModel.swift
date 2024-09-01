//
//  ContentFileViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 31/08/24.
//

import Foundation
import CoreData
class ContentFileViewModel: ObservableObject {
    var dataHandler: CoreDataHandler
    @Published var peerModelData: [PeerModel] = []
    @Published var peerEntityData: [PeerEntity] = []
    init(dataHandler: CoreDataHandler) {
        self.dataHandler = dataHandler
    }
    
    func fetchData(){
        let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
        do {
            peerEntityData =  try dataHandler.viewContext.fetch(request)
            for entityData in peerEntityData {
                peerModelData.append(PeerModel.mapEntityToModel(peerEntity: entityData, context: dataHandler.viewContext))
//                print(PeerModel.mapEntityToModel(peerEntity: peerEntityData, context: dataHandler.viewContext))
            }
            
        } catch {
            print("Error fetching data")
        }
    }
    
    func saveData(){
        for data in peerModelData {
            let peerEntity = PeerEntity(context: dataHandler.viewContext)
            PeerModel.mapModelToEntity(peerModel: data, peerEntity: peerEntity, coreDataHandler: dataHandler    )
//            print("Data Added: \(peerEntity)")
            
            dataHandler.saveData()
            
        }
    }
    func deleteAllData(){
        do {
            let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
            let fetchedPeerEntityData =  try dataHandler.viewContext.fetch(request)
            for data in fetchedPeerEntityData {
                
                dataHandler.viewContext.delete(data)
            }
            dataHandler.saveData()
        } catch {
            print("error")
        }
    }
}
