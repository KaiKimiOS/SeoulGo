//
//  HomeView.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var store: Store
    @State private var areaName: String = "전체지역"
    @State private var sportName: SportName = .전체종목
    
    
    //얼러트
    //store 리팩
    //swiftlint?
    //함수옮겨주기
    //구글배너 아이디
    //이미지 캐싱 ->     완료, 들어갈때마다 호출하는거 줄임. 퍼센트로 몇퍼정도 ? 인거지?
    
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
            VStack(alignment:.leading,spacing:0) {
                
                HStack(spacing:0){
                    Picker("전체종목", selection: $sportName) {
                        ForEach(SportName.allCases, id:\.self) { information in
                            Text("\(information.rawValue)").tag(information)
                        }
                    }
                    
                    Picker("전체지역", selection: $areaName) {
                        ForEach(store.availableArea, id: \.self) { area in
                            Text(area).tag(area)
                        }
                    }
                    
                }
                .padding(.leading,5)
                
                
                List {
                    ForEach(store.finalInformation, id: \.serviceID) { info  in
                        NavigationLink("\(info.serviceName)" ) {
                            DetailView(information: info)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .toolbar {
                
                ToolbarItem(placement:.topBarLeading) {
                    
                    mainHeaderView
                }
            }
        }
        .alert(store.errorType?.errorTitle ?? "에러발생", isPresented: $store.hasError, actions: {
            Button("확인") { }
        }, message: {
            
            if let errorDescription = store.errorType?.errorDescription {
                Text(errorDescription)
            }
        })
        
        .refreshable {
            await store.fetchRequest()
        }
        .onChange(of: sportName.rawValue ) {
            store.getSelectedSport(sport: sportName.rawValue, areaName: areaName)
        }
        .onChange(of:areaName) {
            
            if areaName == "전체지역" || areaName == "지역선택" {
                store.getSelectedSport(sport: sportName.rawValue, areaName: areaName)
            } else {
                store.getSelectedResults(sport: sportName.rawValue, areaName: areaName)
            }
        }
    }
    
    private var mainHeaderView: some View {
        HStack {
            Image("HomeTitle")
                .resizable()
                .frame(width: 120, height: 23, alignment: .center)
            
            if store.storeManager.isEmpty {
                
                ProgressView()
                    .tint(Color.blue)
                    .padding()
            }
                
        }
    }
}
