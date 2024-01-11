//
//  HomeView.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI
import SwiftSoup

struct HomeView: View {
    
    @ObservedObject var information = Network()
    @State var placeInformation: [Row] = []
    @State var initialArea: String = "송파구"
    @State var initialSport: SportName = .축구
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
    
    
    var body: some View {
        
        NavigationStack{
            VStack {
                HStack(alignment:.center){
                    
                    Picker("종목", selection: $initialSport) {
                        
                        ForEach(SportName.allCases, id:\.self) { information in
                            Text("\(information.rawValue)").tag(information)
                        }
                    }
                 
                    Picker("지역", selection: $initialArea) {
                        
                        ForEach(information.placeArea, id: \.self) { information in
                            Text(information)
                        }
                    }
                }
               // .padding()
                List {
                    if placeInformation.isEmpty {
                        Text("구장과 지역을 다시 선택해주세요")
                    } else {
                        ForEach(placeInformation, id: \.serviceID) { information in
                            
                            HStack {
                                NavigationLink("\(information.serviceName)" ) {
                                    DetailView(information: information)
                                    
                                }
                                
                            }
                        }
                    }
                }
                
                Text("\(information.pageNumbers)")
                
                
            }
            .onAppear {
                if !initialBool {
                    Task{
                        await information.getData(sportName: initialSport.rawValue)
                        initialBool = true
                        resetPlaceInformation()
                    }
                } else {return}
            }
            
            .onChange(of: initialSport.rawValue ) { _ in
                Task {
                    await information.getData(sportName: initialSport.rawValue)
                    resetPlaceInformation()
                }
            }
            .onChange(of:initialArea) { _ in
                resetPlaceInformation()
                
            }
            .navigationTitle("SeoulGo")
        }
       
        
    }
    
//   축구장(고양시)-> 종목을 농구로 변경 -> 농구장(고양시) -> 농구장 고양시는 데이터에 존재하지 않음 -> 지역구를 재설정 하면 괜찮지만, 농구장(고양시)에서 종목을 또 바꾸면 풋살장(고양시)가 되어버림 -> 해결방법 농구장에 고양시가 존재하지 않으면 농구장지역의 첫번째를 바로 넣어준다.
    func resetPlaceInformation() {
        
        placeInformation.removeAll()
        placeInformation = information.store[0].ListPublicReservationSport.resultDetails.filter{ $0.areaName == initialArea
        }

        if placeInformation.isEmpty  {
            initialArea = information.placeArea.first ?? "송파구"
        }
    }
}
#Preview {
    HomeView()
}
