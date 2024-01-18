//
//  SeoulGoWidget.swift
//  SeoulGoWidget
//
//  Created by kaikim on 1/16/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    
    static var tempRow:Int = 0
    
    
    func placeholder(in context: Context) ->  SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), temp: Provider.tempRow )
        
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        var tempResult = await Provider.putUserDefaultsToWidget()
        return SimpleEntry(date: Date(), configuration: configuration, temp: tempResult)

    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        var tempResult = await Provider.putUserDefaultsToWidget()
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, temp: tempResult)
            print("Timeline실행시 ⭐️ \(tempResult)")
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    static func putUserDefaultsToWidget() async -> Int {
        
        var fetchNetwork = Network()
        
        do {
            try await fetchNetwork.getData()
            guard let tempRow2 = fetchNetwork.pageNumbers else {return 0}
            print("putUser실행될때 ⭐️\(tempRow2)")
            tempRow = tempRow2
        }
        catch {
            print("\(error.localizedDescription)")
        }

        return tempRow
    }
//    private func putUserDefaultsToLists() {
//        
//        network.favoriteLists?.removeAll()
//        network.favoriteLists?.append(
//            contentsOf:
//                (network.store.first?.ListPublicReservationSport.resultDetails.filter { row in
//                    UserDefaults.standard.dictionaryRepresentation().keys.contains(row.serviceID)
////                    && !network.favoriteLists!.contains(where:{ $0.serviceID == row.serviceID })
//                })!
//        )
//    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let temp: Int
}

struct SeoulGoWidgetEntryView : View {
    var entry: Provider.Entry
   

    var body: some View {
        ZStack{
            Color.orange
            VStack {
                
                Text("\(entry.temp)")
                Text("Time:")
                Text(entry.date, style: .time)
                Text("여기에 쓰면 화면에보인다")
                    .foregroundStyle(.pink)
                Text("Favorite Emoji:")
                Text(entry.configuration.favoriteEmoji)
            }
            .widgetURL(.temporaryDirectory)
            //.padding()
            .background(Color.yellow)
           
        }
        .padding()
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/,width: 5)
    
        .foregroundStyle(.white)
        
        
      
        
    }
 
}

struct SeoulGoWidget: Widget {
    let kind: String = "SeoulGoWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider(), content: { entry in
            SeoulGoWidgetEntryView(entry: entry)
        })
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider(tempRow: 0)) { entry in
//            SeoulGoWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//                
//                
//        }
        .contentMarginsDisabled()
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

//#Preview(as: .systemSmall) {
//    SeoulGoWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}
