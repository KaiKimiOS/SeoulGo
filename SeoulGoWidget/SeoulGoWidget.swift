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
    
    
    @ObservedObject var information = Network.shared
    
    func placeholder(in context: Context) ->  SimpleEntry {
        print("1️⃣")
        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), temp: [])
        
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        print("2️⃣")
        return SimpleEntry(date: Date(), configuration: configuration, temp: [])
        //위젯 추가하려고 꾹 눌러서 seoulgo 검색후 들어가면 그때 호출함.
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        //바탕화면에 seoulgo 위젯이 하나면 한번, 두개가 존재하면 2번 호출됨.
        print("3️⃣")
//        await putUserDefaultsToWidget()
        
        let currentDate = Date()
        
        var entries = SimpleEntry(date: currentDate, configuration: configuration, temp: [])
        //        for hourOffset in 0 ..< 5 {
        //            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
        //            let entry = SimpleEntry(date: entryDate, configuration: configuration, temp: information.favoriteLists!)
        //
        //            entries.append(entry)
        //        }
        
        return Timeline(entries: [entries], policy: .atEnd)
    }
    
//    func putUserDefaultsToWidget() async -> [Row]{
//        
//        do {
//            try await information.getData()
//            let tempShared = UserDefaults(suiteName: "group.kaikim.SeoulGo")?.dictionaryRepresentation().keys
//            var checkID = information.store.first?.ListPublicReservationSport.resultDetails.filter{ row in tempShared!.contains(row.serviceID) }
//            
//            guard let ok = checkID else {print("노노노놉");return []}
//            information.favoriteLists?.removeAll()
//            for i in ok {
//                information.favoriteLists?.append(i)
//                
//            }
//            print("4️⃣")
//
//            return information.favoriteLists!
//        }catch {
//            
//            print(error.localizedDescription)
//        }
//        
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

        VStack(spacing:0) {

            HStack(spacing:0){
                Text("SeoulGo")
                    .lineLimit(1)
                    .allowsTightening(true)
                    .foregroundStyle(.cyan)
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
                
                
                ForEach(0..<min(entry.temp.count, 2)) { i in
                    HStack(spacing:0) {
                        
                        
                        Text("[\(entry.temp[i].minClass)] ")
                        Text("\(entry.temp[i].placeName)")
                    }
                    .lineLimit(1)
                    .allowsTightening(true)
                    .foregroundStyle(.black)
                    .font(.caption2)
                    .fontWeight(.light)
                    .truncationMode(.tail)
                    
                }
            }
            Spacer()
            // .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            
        }
        
        .padding()
        .widgetURL(.temporaryDirectory)
        .foregroundStyle(.black)
        
        
        
        
    }
    
}

struct SeoulGoWidget: Widget {
    let kind: String = "SeoulGoWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider(), content: { entry in
            
            SeoulGoWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
            
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
