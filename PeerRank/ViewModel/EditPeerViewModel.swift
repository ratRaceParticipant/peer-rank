//
//  EditPeerViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import Foundation
import SwiftUI
import CoreData
class EditPeerViewModel: ObservableObject {
    @Published var peerModel: PeerModel
    @Published var peerImage: UIImage?
    @Published var peerRatingWeightage: Double = 0.0
    @Published var peerRating: Float = 3.0
    var localFileManager: LocalFileManager
    var coreDataHandler: CoreDataHandler
    var updateParentVarData: ((_ peerDataModel: PeerModel, _ peerImage: UIImage?) -> Void)?
    init(
        localFileManager: LocalFileManager, 
        coreDatHandler: CoreDataHandler,
        peerModel: PeerModel,
        peerImage: UIImage?,
        onChange: ((_ peerDataModel: PeerModel, _ peerImage: UIImage?) -> Void)? = nil
    ){
        self.localFileManager = localFileManager
        self.coreDataHandler = coreDatHandler
        self.peerModel = peerModel
        self.peerRatingWeightage = Double(peerModel.baseRatingWeightage)
        self.peerRating = Float(peerModel.baseRating)
        self.peerImage = peerImage
        self.updateParentVarData = onChange
    }
    
    func writePeerData(isUpdate: Bool = false){
        
        let peerEntity = isUpdate ?
        PeerModel.getEntityFromDataModelId(
            peerId: peerModel.peerId,
            viewContext: coreDataHandler.viewContext
        ) :
        PeerEntity(context: coreDataHandler.viewContext)
        guard let peerEntity else {
            print("error in updating")
            return
        }
        setPeerData()
        saveImage()
        deleteImage()
        PeerModel.mapModelToEntity(
            peerModel: peerModel,
            peerEntity: peerEntity,
            coreDataHandler: coreDataHandler
        )
        print("peerId Written: \(peerEntity.peerId)")
        coreDataHandler.saveData()
        
    }
    
    
    func setPeerData() {
        peerModel.id = UUID()
        peerModel.initials = getInitialsFromName(name: peerModel.name)
        peerModel.baseRatingWeightage = Int16(peerRatingWeightage)
        peerModel.baseRating = Int16(peerRating)
        peerModel.averageRating = peerRating
//        peerModel.peerId = UUID().uuidString
    }
    
    
    
    func getInitialsFromName(name: String) -> String {
        let nameArray: [String] = name.components(separatedBy: " ")
        var initials: String = ""
        if nameArray.count == 1 {
            initials = String(nameArray[0].prefix(2))
        } else {
            for word in nameArray {
                if initials.count == Constants.maxInitialsLength {
                    return initials.uppercased()
                } else {
                    if let letter = word.first {
                        initials += String(letter)
                    }
                }
            }
        }
        return initials.uppercased()
    }
    
    func saveImage(){
        guard let uiImage = peerImage else { return }   
        peerModel.photoId = peerModel.photoId.isEmpty ? UUID().uuidString : peerModel.photoId
        localFileManager.saveImage(image: uiImage, id: peerModel.photoId)
    }
    
    func deleteImage(){
        guard let _ = peerImage else {
            if !(peerModel.photoId == "") {
                localFileManager.deleteImage(id: peerModel.photoId)
                peerModel.photoId = ""
            }
            return
        }
        
    }
    
}
