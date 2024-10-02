//
//  PeerInstancesChartViewModel.swift
//  PeerRank
//
//  Created by Himanshu Karamchandani on 30/09/24.
//

import Foundation
class PeerInstancesChartViewModel: ObservableObject {
    var coreDataHandler: CoreDataHandler
    var peerData: PeerModel
    @Published var chartPeerDataModel: PeerModel? = PeerModel.sampleData[0]
    @Published var ratings: [Double] = []
    init(
        coreDataHandler: CoreDataHandler,
        peerDataModel: PeerModel
    ) {
        self.coreDataHandler = coreDataHandler
        self.peerData = peerDataModel
    }
    
    func getDataForChart() {
        let data = CommonFunctions.fetchPeerData(
            viewContext: coreDataHandler.viewContext,
            localFileManager: nil,
            
            filter: NSPredicate(format: "peerId == %@", peerData.peerId),
            
            mapPeerImage: false
        )
        
        guard !data.isEmpty else {return}
        chartPeerDataModel = data[0]
        ratings = getRatingsFromChartData()
//        print(chartPeerDataModel)
    }
    
    func getRatingsFromChartData() -> [Double] {
        guard let chartPeerDataModel else {
            return []
        }
        let data = chartPeerDataModel.peerInstance.sorted{
            $0.instanceDate < $1.instanceDate
        }
       return  data.map { data in
            Double(data.averageRatingAtTimeOfInstance)
        }
    }
}
