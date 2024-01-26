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
    @State var initialArea: String = "지역"
    @State var initialSport: SportName = .전체
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
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment:.leading) {
               
                HStack(alignment:.center){
                  
                    Picker("종목", selection: $initialSport) {
                        
                        ForEach(SportName.allCases, id:\.self) { information in
                            Text("\(information.rawValue)").tag(information)
                        }
                    }
                    //.border(Color.black)
                 
                    Picker("지역", selection: $initialArea) {
                        
                        ForEach(store.allArea, id: \.self) { area in
                            Text(area)
                        }
                    }
                    //.border(Color.black)
                    Text("종목과 지역을 선택해주세요")
                        .foregroundStyle(.gray)
                        .font(.caption)
                        .fontWeight(.light)
                        .lineLimit(1)
                        .padding(.leading,5)
                  
                }
                .padding([.leading], 10)
                List {

                    if initialSport == .전체 {
                        ForEach(store.storeManager, id:\.serviceID) { info in
                            HStack {
                                NavigationLink("\(info.serviceName)" ) {
                                    DetailView(information: info)
                                    
                                }
                                
                            }

                            
                        }
                    } else {
                    ForEach(store.selectedResults, id: \.serviceID) { info  in
                            
                            HStack {
                                NavigationLink("\(info.serviceName)" ) {
                                    DetailView(information: info)
                                    
                                }
                                
                            }
                        }
                    }
                }
                
            }
            .onAppear {
            
                if !initialBool {
                    Task{
                        await store.fectRequest()
                        initialBool = true
                    }
                } else {return}
                
            }
            
            .onChange(of: initialSport.rawValue ) { _ in
                store.getSelectedArea(sport: initialSport.rawValue)

            }
            .onChange(of:initialArea) { _ in
                store.getSelectedResults(sport: initialSport.rawValue, areaName: initialArea)
                
            }
            .navigationTitle("SeoulGo")
 
        }
       
        
    }
    
//   축구장(고양시)-> 종목을 농구로 변경 -> 농구장(고양시) -> 농구장 고양시는 데이터에 존재하지 않음 -> 지역구를 재설정 하면 괜찮지만, 농구장(고양시)에서 종목을 또 바꾸면 풋살장(고양시)가 되어버림 -> 해결방법 농구장에 고양시가 존재하지 않으면 농구장지역의 첫번째를 바로 넣어준다.
//    func resetPlaceInformation() {
//        
//        placeInformation.removeAll()
//        placeInformation = information.store[0].ListPublicReservationSport.resultDetails.filter{ $0.areaName == initialArea
//        }
//
//        if placeInformation.isEmpty  {
//            initialArea = information.placeArea.first ?? "송파구"
//        }
//    }
}
#Preview {
    HomeView()
}