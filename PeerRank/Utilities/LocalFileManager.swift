//
//  LocalFileManager.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 08/09/24.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    
    func saveImage(image: UIImage, id: String){
        
        guard
           
            let data = image.jpegData(compressionQuality: 0.5),
            let path = getPathForImage(id: id)
        else {
            print("Error getting image path")
            return
        }
        do {
            try data.write(to: path)
            print("image saved")
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    func getImage(id: String) -> UIImage? {
        guard
            let path = getPathForImage(id: id)?.path(percentEncoded: false),
            FileManager.default.fileExists(atPath: path) else {
            print("Error getimage()")
            return nil
        }
        return UIImage(contentsOfFile: path)
    }
    
    func deleteImage(id: String) {
        guard
            let path = getPathForImage(id: id),
            FileManager.default.fileExists(atPath: path.path(percentEncoded: false)) else {
            print("Error deleteimage()")
            return
        }
        do {
            try FileManager.default.removeItem(at: path)
            print("Image deleted successfully")
        } catch {
            print("Error deleting image")
        }
    }
    
    func getPathForImage(id: String) -> URL?{
        guard
            let path = FileManager
                .default
                .urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appending(path: "\(id).png")
        else {
            print("Erroe getting path")
            return nil
        }
        return path
    }
}
