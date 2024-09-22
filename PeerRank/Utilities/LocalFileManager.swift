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
           
            let data = image.jpegData(compressionQuality: 0.3),
            let path = getPathForImage(id: id)
        else {
            print("Error getting image path")
            return
        }
        do {
            try data.write(to: path)
            print("image saved on: \(id)")
        } catch {
            print("Error saving image: \(error)")
        }
    }
    
    func getImage(id: String) -> UIImage? {
        guard
            let path = getPathForImage(id: id)?.path(percentEncoded: false),
            FileManager.default.fileExists(atPath: path) else {
            print("Error getimage() on \(id)")
            return nil
        }
        
        return downsample(imageAt: getPathForImage(id: id), to: CGSize(width: 100, height: 100))
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
                .appending(path: "\(id).jpg")
        else {
            print("Erroe getting path")
            return nil
        }
        return path
    }
    func downsample(imageAt imageURL: URL?,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {
        guard let imageURL else {return nil}
        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }
}
