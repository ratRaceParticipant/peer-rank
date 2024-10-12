//
//  PopupView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 12/10/24.
//

import SwiftUI

struct PopupView: View {
    var loadingStatus: LoadingStatus = .inprogress
    @State var displayText: String = LoadingStatus.inprogress.getStatus()
    @State var trimValue: CGFloat = 0.95
    @Namespace var animation
    @State var degrees = 0.0
    @State var checkMarkScale = 0.0
    var body: some View {
        ZStack {
            
            VStack(spacing: 15) {
                ZStack {
                    RoundedRectangle(cornerRadius: 35,style: .continuous)
                        .trim(from: 0.0,to: trimValue)
                        .stroke()
                        .matchedGeometryEffect(id: "animation", in: animation)
                        .frame(width: 70,height: 70)
                        .rotationEffect(.degrees(degrees))
                        .foregroundStyle(.primary)
                    
                    Image(systemName: loadingStatus.getIcon())
                        .foregroundColor(loadingStatus.getColor())
                        .font(.title)
                        .bold()
                        .scaleEffect(checkMarkScale)
                }
                Text(displayText)
                    .fontWeight(.bold)
            }
            .onChange(of: loadingStatus, { oldValue, newValue in
                withAnimation(
                    .easeInOut(duration: 1.0).repeatForever(autoreverses: false)
                    ){
                    degrees = 360
                }
                
                if loadingStatus != .inprogress, loadingStatus != .notStarted {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1.5){
                        displayText = loadingStatus.getStatus()
                        withAnimation(.linear) {
                            trimValue = 1.0
                            checkMarkScale = 1.0
                        }
                    }
                }
                
            })
            .frame(width: 200,height: 200)
            
            .background(
                .thinMaterial
            )
            .cornerRadius(25)
            
        }
    }
}

#Preview {
    PopupView()
}
