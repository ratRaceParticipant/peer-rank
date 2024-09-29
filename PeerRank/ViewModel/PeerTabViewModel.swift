//
//  PeerTabViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import CoreData
import SwiftUI
@MainActor
class PeerTabViewModel: ObservableObject {
    
    @Published var peerModelData: [PeerModel] = []
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager) {
        
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
        
    }
    
    func fetchData(lastSelectedPeerModel: PeerModel?) async {
        
        guard let lastSelectedPeerModel else {
            
            await fetchAllData()
            return
        }
        await fetchSingleData(lastSelectedPeerModel: lastSelectedPeerModel)
    }
    func fetchSingleData(lastSelectedPeerModel: PeerModel) async {
        
        let peerEntityData =  PeerModel.getEntityFromDataModelId(peerId: lastSelectedPeerModel.peerId, viewContext: coreDataHandler.viewContext)
        guard let peerEntityData else  {return}
        var newPeerModelData = PeerModel.mapEntityToModel(peerEntity: peerEntityData, context: coreDataHandler.viewContext)
        
        newPeerModelData.peerImage = await getImage(peerDataModel: newPeerModelData)
        
        let indexToUpdateData = peerModelData.firstIndex { peerModel in
            peerModel.peerId == newPeerModelData.peerId
        }
        guard let indexToUpdateData else {
            
            return
        }
        peerModelData[indexToUpdateData] = newPeerModelData
        return
    }
    
    func fetchAllData() async {
        let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
        do {
            var data: [PeerModel] = []
            let peerEntityData =  try coreDataHandler.viewContext.fetch(request)
            for entityData in peerEntityData {
                let peerModelData =  PeerModel.mapEntityToModel(
                                            peerEntity: entityData,
                                            context: coreDataHandler.viewContext
                                    )
                
                data.append(
                   peerModelData
                )
            }
            peerModelData = data
            await mapImagesToPeer()
            
        } catch {
            print("Error fetching data")
        }
    }
    
    func mapImagesToPeer() async {
//        try? await Task.sleep(nanoseconds: 3_000_000_000)
        for (index, data) in peerModelData.enumerated() {
            peerModelData[index].peerImage = await getImage(peerDataModel: data)
        }
    }
    
    func getImage(peerDataModel: PeerModel) async -> UIImage?{
        
        guard !(peerDataModel.photoId == "") else {
            
            return nil
        }
        let image = localFileManager.getImage(id: peerDataModel.photoId)
        
        return image
    }
}
