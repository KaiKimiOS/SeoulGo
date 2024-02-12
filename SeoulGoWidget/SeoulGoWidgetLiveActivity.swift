//
//  SeoulGoWidgetLiveActivity.swift
//  SeoulGoWidget
//
//  Created by kaikim on 1/16/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SeoulGoWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SeoulGoWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SeoulGoWidgetAttributes.self) { context in
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

extension SeoulGoWidgetAttributes {
    fileprivate static var preview: SeoulGoWidgetAttributes {
        SeoulGoWidgetAttributes(name: "World")
    }
}

extension SeoulGoWidgetAttributes.ContentState {
    fileprivate static var smiley: SeoulGoWidgetAttributes.ContentState {
        SeoulGoWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SeoulGoWidgetAttributes.ContentState {
         SeoulGoWidgetAttributes.ContentState(emoji: "🤩")
     }
}

//#Preview("Notification", as: .content, using: SeoulGoWidgetAttributes.preview) {
//   SeoulGoWidgetLiveActivity()
//} contentStates: {
//    SeoulGoWidgetAttributes.ContentState.smiley
//    SeoulGoWidgetAttributes.ContentState.starEyes
//}
