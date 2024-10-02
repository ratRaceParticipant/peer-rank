//
//  PeerInstancesChartView.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 30/09/24.
//

import SwiftUI
import SwiftUICharts
struct PeerInstancesChartView: View {
    @StateObject var vm: PeerInstancesChartViewModel
    let chartStyle = ChartStyle(backgroundColor: .clear, accentColor: .yellow, secondGradientColor: .yellow, textColor:.primary, legendTextColor: Color.white, dropShadowColor: .clear )
    let appPearUrl: URL? = URL(string: "https://github.com/AppPear/ChartView")
    init(
        coreDataHandler: CoreDataHandler,
        peerData: PeerModel
    ){
        self._vm = StateObject(
            wrappedValue: PeerInstancesChartViewModel(
                coreDataHandler: coreDataHandler,
                peerDataModel: peerData
            )
        )
    }
    var body: some View {
        Group{
            if !vm.getRatingsFromChartData().isEmpty {
                VStack {
                    LineView(data: vm.getRatingsFromChartData(),style: chartStyle)
                        .frame(height: 280)
                    if let appPearUrl {
                        HStack {
                            Spacer()
                            Link(destination: appPearUrl) {
                                Text("Charts are Provied by AppPear Github")
                                    .font(.caption2)
//                                    .padding(.trailing,8)
                                    
                            }
                        }
                    }
                        
                }
                    
            } else {
                Text("Not Enough Data Available")
            }
        }
        .onAppear{
            vm.getDataForChart()
        }
    }
}

#Preview {
    PeerInstancesChartView(
        coreDataHandler: CoreDataHandler(), peerData: PeerModel.emptyData
    )
}
