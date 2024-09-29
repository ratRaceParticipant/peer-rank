//
//  PeerRankWidget.swift
//  PeerRankWidget
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    static let coreDataHandler = CoreDataHandler()
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .never)
    }
    
    static func getData(fetchTopRatedPeers: Bool = true) -> [PeerModel]{
        let peerDataModel: [PeerModel] =
        CommonFunctions.fetchBannerData(fetchTopRatedPeers: fetchTopRatedPeers, viewContext: coreDataHandler.viewContext)
        return peerDataModel
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct PeerRankWidgetEntryView : View {
    var entry: Provider.Entry
    var peerDataModel: [PeerModel]
    var body: some View {
        WidgetView(peerDataModel: peerDataModel,fetchTopRatedPeers: false)
            
            .containerBackground(.pink, for: .widget)
            
    }
}

struct PeerRankWidget: Widget {
    let kind: String = "PeerRankWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            PeerRankWidgetEntryView(entry: entry, peerDataModel: Provider.getData())
                
                
        }
//        .supportedFamilies([.systemSmall])
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemSmall) {
    PeerRankWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    
}
