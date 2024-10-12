//
//  CustomShareSheetView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 12/10/24.
//

import UIKit
import SwiftUI

struct CustomShareSheetView: UIViewControllerRepresentable {
    @Binding var url: URL?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: [url as Any], applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}


