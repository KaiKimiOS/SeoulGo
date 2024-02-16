//
//  HomeView.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI
import SwiftSoup

struct HomeView: View {
    
    @EnvironmentObject var store:Store
    @State var placeInformation: [Row] = []
    @State var initialArea: String = "전체지역"
    @State var initialSport: SportName = .전체종목
    @State var initialBool:Bool = false //처음 화면 진입시 호출 및 재호출 방지를 위한 Bool값
    
    
    //에러1
    //ForEach로 화면 표시할때 에러발생 -> ForEach<Array<String>, String, Text>: the ID 성동구 occurs multiple times within the collection, this will give undefined results!
    
    //에러2
    //    fopen failed for data file: errno = 2 (No such file or directory)
    //    Errors found! Invalidating cache...
    
    
    //API 호출 줄이기
    //네이버 지도앱 뛰우기
    
    // 예약 페이지 -> 인앱 사파리
    
    // 종목별 enum처리
    //중복처리 Set으로
    
    // UserDefaults.standard.dictionaryRepresentation().key 로 해주기
    
    //종목을 다른거 축구장, 농구장 노르면 무조건 전체가 먼저 나오도록 하기
    
    
    
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment:.leading) {
                
                HStack(alignment:.center){
                    
                    Picker("전체종목", selection: $initialSport) {
                        ForEach(SportName.allCases, id:\.self) { information in
                            Text("\(information.rawValue)").tag(information)
                        }
                    }
                    
                    Picker("전체지역", selection: $initialArea) {
                        ForEach(store.availableArea, id: \.self) { area in
                            Text(area).tag(area)
                        }
                    }
                    HStack{
                        Text("종목과 지역을 선택해주세요")
                            .foregroundStyle(.gray)
                            .font(.caption)
                            .fontWeight(.light)
                            .lineLimit(1)
                        //                            .padding(.trailing)
                        
                        if store.storeManager.isEmpty {
                            ProgressView()
                                .tint(Color.blue)
                            
                        }
                    }
                    
                }
                .padding(.leading, 5)
                
                
                List {
                    
                    ForEach(store.finalInformation, id: \.serviceID) { info  in
                        
                        HStack {
                            NavigationLink("\(info.serviceName)" ) {
                                DetailView(information: info)
                                
                            }
                            
                        }
                    }
                }
                
                .listStyle(.plain)
                
            }
            .onAppear {
                
                if !initialBool {
                    Task{
                        await store.fetchRequest()
                        initialBool = true
                    }
                }
            }
            
            .onChange(of: initialSport.rawValue ) { _ in
                store.getSelectedSport(sport: initialSport.rawValue, areaName: initialArea)
                
            }
            .onChange(of:initialArea) { _ in
                
                if initialArea == "전체지역" || initialArea == "지역선택" {
                    store.getSelectedSport(sport: initialSport.rawValue, areaName: initialArea)
                } else {
                    store.getSelectedResults(sport: initialSport.rawValue, areaName: initialArea)
                }
                
                
                
            }
            .navigationTitle("SeoulGo")
            
        }
        
        
    }
}
//#Preview {
//   ContentView()
//}
