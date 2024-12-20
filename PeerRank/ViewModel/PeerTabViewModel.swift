//
//  PeerTabViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import CoreData
import SwiftUI
import Combine
@MainActor
class PeerTabViewModel: ObservableObject {
    
    @Published var peerModelData: [PeerModel] = []
    var coreDataHandler: CoreDataHandler
    var localFileManager: LocalFileManager
    @Published var isSelectedDataDeleted: Bool = false
    @Published var loadingStatus: LoadingStatus = .inprogress
    @Published var searchText: String = ""
    @Published var fetchTask: Task<(), Never>? = nil
    let searchTextPublisher = PassthroughSubject<String, Never>()
    init(coreDataHandler: CoreDataHandler, localFileManager: LocalFileManager) {
        
        self.coreDataHandler = coreDataHandler
        self.localFileManager = localFileManager
        
    }
    
    func fetchData(lastSelectedPeerModel: PeerModel?) async {
        loadingStatus = .inprogress
        guard let lastSelectedPeerModel, !isSelectedDataDeleted else {
            
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
        loadingStatus = .complete
        return
    }
    
    func fetchAllData() async {
        peerModelData = []
        let request: NSFetchRequest<PeerEntity> = PeerEntity.fetchRequest()
        let predicate = NSPredicate(format: "name LIKE %@", "*\(searchText)*")
        request.predicate = searchText.isEmpty ? nil : predicate
        do {
            
            let peerEntityData =  try coreDataHandler.viewContext.fetch(request)
            for entityData in peerEntityData {
                let data =  PeerModel.mapEntityToModel(
                                            peerEntity: entityData,
                                            context: coreDataHandler.viewContext
                                    )
                
                peerModelData.append(
                   data
                )
            }
            loadingStatus = .complete
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
    
//    func searchTextSubscriber() async {
//        $searchText
//            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
//            .sink {_ in 
//                await fetchAllData()
//            }
//            .store(in: &disposeBag)
//    }
}
