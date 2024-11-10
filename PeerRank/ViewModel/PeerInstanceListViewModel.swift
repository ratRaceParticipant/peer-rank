//
//  PeerInstanceListViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 14/09/24.
//

import Foundation
import CoreData
class PeerInstanceListViewModel: ObservableObject {
    
    @Published var peerInstanceModel: [PeerInstanceModel] = []
    var peerModel: PeerModel
    var coreDataHandler: CoreDataHandler
    var ratedPeerModel: RatedPeerModel?
    init(
        peerModel: PeerModel,
        coreDataHandler: CoreDataHandler,
        ratedPeerModel: RatedPeerModel?
    ) {
        self.peerModel = peerModel
        self.coreDataHandler = coreDataHandler
        self.ratedPeerModel = ratedPeerModel
    }
    
    func fetchPeerInstnaceData() {
        let request: NSFetchRequest<PeerInstanceEntity> = PeerInstanceEntity.fetchRequest()
        request.predicate = NSPredicate(format: "peer = %@",
                                        PeerModel.getEntityFromDataModelId(
                                            peerId: peerModel.peerId,
                                            viewContext: coreDataHandler.viewContext
                                        ) ?? PeerEntity(context: coreDataHandler.viewContext)
        )
        do {
            var data: [PeerInstanceModel] = []
            let peerInstanceEntityData =  try coreDataHandler.viewContext.fetch(request)
            for entityData in peerInstanceEntityData {
                let peerModelData =  PeerInstanceModel.mapEntityToModel(
                                            peerInstanceEntity: entityData
                                    )
                
                
                data.append(
                   peerModelData
                )
            }
            peerInstanceModel = data
            
            
        } catch {
            print("Error fetching data")
        }
    }
}
