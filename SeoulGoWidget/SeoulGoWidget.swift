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


struct Provider: TimelineProvider {
    
    @ObservedObject var store: Store = Store()
    @State var initalBool:Bool = false
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), temp: store.favoriteLists)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        
        completion(SimpleEntry(date: Date(), temp: store.favoriteLists))
        
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        Task{
            await putUserDefaultsToWidget()
            let currentDate = Date()
            var entries = SimpleEntry(date: currentDate, temp: store.favoriteLists)
            completion(Timeline(entries: [entries], policy: .atEnd))
        }
        
    }
    
    func putUserDefaultsToWidget() async {
        
        if !initalBool {
            await store.fetchRequest()
            initalBool = true
        }
        store.putUserDefaultsToLists()
        store.putlistToDictionary()
    }
    
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let temp: [Row]
}

struct SeoulGoWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        VStack(spacing:10) {
            
            HStack(spacing:5){
                Image("SeoulGoImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
             
                
                Text("즐겨찾기")
                    .lineLimit(1)
                    .allowsTightening(true)
                    .foregroundStyle(.cyan)
                    .font(.headline)
                    .fontWeight(.bold)
            }
            
            VStack(alignment:.leading,spacing: 5){
                ForEach(0..<min(entry.temp.count, 4)) { i in
                    HStack(spacing:0) {
                        Text("[\(entry.temp[i].minClass)] ")
                        Text("\(entry.temp[i].placeName)")
                    }
                    .lineLimit(1)
                    .allowsTightening(true)
                    .font(.caption2)
                    .fontWeight(.light)
                    .truncationMode(.tail)
                   
                }
                if entry.temp.count > 4 {
                    Text("\(entry.temp.count - 4)개 즐겨찾기가 더 있습니다")
                        .font(.caption2)
                        .fontWeight(.light)
                }
            }
//            Spacer()
        }
        .padding()
        .widgetURL(.temporaryDirectory)
    }
}

struct SeoulGoWidget: Widget {
    let kind: String = "SeoulGoWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            
            SeoulGoWidgetEntryView(entry: entry)
                .containerBackground(.clear, for: .widget)
            
        }
        
        .supportedFamilies([.systemSmall])
        .configurationDisplayName("즐겨찾기")
        .description("즐겨찾기에 추가한 리스트를 위젯으로 볼 수 있어요.")
        .contentMarginsDisabled()
        //마진을 꽉꽉채워서 다쓸건지
    }
    
}

#Preview(as: .systemSmall) {
    SeoulGoWidget()
} timeline: {
    SimpleEntry(date: .now,  temp: [])
    
}
