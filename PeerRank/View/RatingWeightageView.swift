//
//  RatingWeightageView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 07/09/24.
//

import SwiftUI

struct RatingWeightageView: View {
    @Binding var ratingWeightage: Double
    @State private var isEditing = false
    var body: some View {
        HStack {
            Text("Rating Weightage")
                .font(.headline)
                .fontWeight(.bold)
            Text("\(ratingWeightage, specifier: "%.f")")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(isEditing ? .red : .accentColor)
            IconWithPopoverView(popOverText: .baseRatingWeightageInfo)
            Spacer()
        }
        Slider(value: $ratingWeightage, in: 1...20, step: 1.0){
            Text("Slider")
        } minimumValueLabel: {
            Text("1")
        } maximumValueLabel: {
            Text("20")
        } onEditingChanged: { editing in
            isEditing = editing
        }
        
    }
}

#Preview {
    RatingWeightageView(ratingWeightage: .constant(2.0))
}
