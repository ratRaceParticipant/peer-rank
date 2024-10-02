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
    @Published var peerRatingWeightage: Double = 1.0
    @Published var peerRating: Float = 3.0
    @Published var validationStatus: ValidationStatus = .noError
    @Published var validationErrorMessage: String = ""
    @Published var showValidationError: Bool = false
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
        
        validationStatus = CommonFunctions.validatePeerData(peerDataModel: peerModel)
        
        guard validationStatus == .noError else {
            validationErrorMessage = validationStatus.getValidationError()
            showValidationError = true
            return
        }
        
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
        setPeerData(isUpdate: isUpdate)
        saveImage()
        deleteImage()
        
        PeerModel.mapModelToEntity(
            peerModel: peerModel,
            peerEntity: peerEntity,
            coreDataHandler: coreDataHandler
        )
        
        coreDataHandler.saveData()
        setAverageRating(peerEntity: peerEntity)
    }
    
    
    func setPeerData(isUpdate: Bool) {
        peerModel.id = UUID()
        peerModel.initials = CommonFunctions.getInitialsFromName(name: peerModel.name)
        peerModel.baseRatingWeightage = Int16(peerRatingWeightage)
        peerModel.baseRating = Int16(peerRating)
        peerModel.averageRating = peerRating
        peerModel.peerImage = peerImage
        if !isUpdate {
            peerModel.peerId = UUID().uuidString
        }
    }
    
    func setAverageRating(peerEntity: PeerEntity){
        let averageRating = CommonFunctions.getPeerAverageRating(
            from: peerModel, viewContext: coreDataHandler.viewContext
        ) ?? peerModel.averageRating
        
        peerEntity.averageRating = averageRating
        coreDataHandler.saveData()
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
