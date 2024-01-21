//
//  SeoulGoWidget.swift
//  SeoulGoWidget
//
//  Created by kaikim on 1/16/24.
//

import WidgetKit
import SwiftUI

//Provider에서 API를 호출하고, 받아와서 변수 A에 저장을 한다. 그리고 userDefault.쉐어(앱과위젯을 쉐어)하는 곳과 비교하며서, UserDefault의 serviceID가 변수 A가 가지고 있으면, 그 Row를 보여준다.
//onchange를 통해서 UserDefault에 변화가 있다면, 다시 func 실행해서 변화를 위젯 view에 바로 보여준다.
// 해결 -> 그걸 누르면 거기로 바로 들어가게해야함

struct Provider: AppIntentTimelineProvider {
    
    static var shared = Network()
    static var tempRow:Int = 0
    static var widgetStore:[Row] = []
    
    func placeholder(in context: Context) ->  SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), temp: Provider.widgetStore )
        
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        var tempResult = await Provider.putUserDefaultsToWidget()
        return SimpleEntry(date: Date(), configuration: configuration, temp: Provider.widgetStore)
        
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        
        var tempResult = await Provider.putUserDefaultsToWidget()
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, temp: Provider.widgetStore)
            print("Timeline실행시 ⭐️ \(tempResult)")
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
    
    static func putUserDefaultsToWidget() async -> Int {
        
        var tempShared = UserDefaults(suiteName: "group.kaikim.SeoulGo")?.dictionaryRepresentation()
        
        do {
            try await shared.getData()
            guard let tempRow2 = shared.pageNumbers else {return 0}
            print(shared.store)
            print(tempShared)
            widgetStore.removeAll()
            widgetStore.append(contentsOf: (shared.store.first?.ListPublicReservationSport.resultDetails.filter{ row in tempShared!.keys.contains(row.serviceID) })!)
            print("⭐️⭐️⭐️ \(widgetStore)")
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
    let temp: [Row]
}

struct SeoulGoWidgetEntryView : View {
    var entry: Provider.Entry
    
    
    var body: some View {
        //        ZStack{
        //            Color.orange
        VStack(spacing:0) {
            //Text(entry.date, style: .time)
            HStack(spacing:0){
                Text("SeoulGo")
                    .lineLimit(1)
                    .allowsTightening(true)
                    .foregroundStyle(.red)
                    .font(.headline)
                    .fontWeight(.bold)
                  
                Image("SeoulGoImage")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .scaledToFit()
                    .clipShape(.circle.inset(by: 10))
//                    .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
//
            }
//            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            
            VStack(alignment:.leading,spacing: 5){
              

                ForEach(0..<3) { i in
                    HStack(spacing:0) {
                        
                        Text("[\(entry.temp[i].serviceStatus)-\(entry.temp[i].minClass)] ")
                        Text("\(entry.temp[i].placeName)")
                        
                    }
                    .lineLimit(1)
                    .allowsTightening(true)
                    .foregroundStyle(.red)
                    .font(.callout)
                    .fontWeight(.light)
                   
                }
//                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
              
//
//                    
//               
//                    
//                    Text("Time:마마마마마마마마")
//                    
//                    Text(entry.date, style: .time)
//                    
//                    Text("여기에 쓰면 화면에")
//                        .foregroundStyle(.pink)
                }
            Spacer()
           // .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
           
        }
//        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .padding()
        .widgetURL(.temporaryDirectory)
        .background(Color.yellow)
//        .border(Color.black)
        
        //        }
        //        .padding()
        //        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/,width: 5)
        //
        .foregroundStyle(.black)
        
        
        
        
    }
    
}

struct SeoulGoWidget: Widget {
    let kind: String = "SeoulGoWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider(), content: { entry in
            
            SeoulGoWidgetEntryView(entry: entry)
                .containerBackground(.yellow, for: .widget)
                
        })
        .contentMarginsDisabled()
        //마진을 꽉꽉채워서 다쓸건지
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
    SeoulGoWidget()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley, temp: [])
    
}
