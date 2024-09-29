//
//  PeerRankWidgetLiveActivity.swift
//  PeerRankWidget
//
//  Created by Himanshu Karamchandani on 28/09/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct PeerRankWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct PeerRankWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: PeerRankWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension PeerRankWidgetAttributes {
    fileprivate static var preview: PeerRankWidgetAttributes {
        PeerRankWidgetAttributes(name: "World")
    }
}

extension PeerRankWidgetAttributes.ContentState {
    fileprivate static var smiley: PeerRankWidgetAttributes.ContentState {
        PeerRankWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: PeerRankWidgetAttributes.ContentState {
         PeerRankWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: PeerRankWidgetAttributes.preview) {
   PeerRankWidgetLiveActivity()
} contentStates: {
    PeerRankWidgetAttributes.ContentState.smiley
    PeerRankWidgetAttributes.ContentState.starEyes
}
