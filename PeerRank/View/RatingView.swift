//
//  RatingView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI

struct RatingView: View {
    @Binding var currentRating: Float
    var enableEditing: Bool = true
    var starFont: Font = .title
    var body: some View {
        VStack(alignment: .leading) {
            if enableEditing {
                Text("Base Rating")
                    .fontWeight(.bold)
            }
                starView
                    .overlay {
                        overlayView
                            .mask(starView)
                    }
        }
    }
    var overlayView: some View {
         
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: CGFloat(currentRating) / 5 * geometry.size.width)
                }
            }
            .allowsHitTesting(false)
            
        
    }
    var starView: some View {
        HStack {
            ForEach(1..<6) { index in
                Image(systemName: "star.fill")
                    .font(starFont)
                    .foregroundColor(Int(currentRating) >= index ? .yellow : .gray)
                    .onTapGesture {
                        if enableEditing {
                            withAnimation(.spring()) {
                                currentRating = Float(index)
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    RatingView(currentRating: .constant(3))
}
