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
    @State var abcd: String = "송파구"
    @State var dddd: SportName = .축구
    
    enum SportName:String, CaseIterable {
        case 축구 = "축구장"
        case 농구 = "농구장"
        case 풋살 = "풋살장"
        case 테니스 = "테니스장"
        case 족구 = "족구장"
        case 야구 = "야구장"
        case 배드민턴 = "배드민턴장"
        case 배구 = "배구장"
        case 다목적경기장 = "다목적경기장"
    }
    //각 종목이 있는 지역이 있다. 그걸 나눠야함.
    //API 호출 줄이기
    // 종목별 enum처리
    
    var body: some View {
        
        NavigationStack{
            VStack {
                
                List {
                    if placeInformation.first == nil {
                        Text("구장과 지역을 다시 선택해주세요")
                    } else {
                        ForEach(placeInformation, id: \.serviceID) { information in
                            
                            HStack{
                                NavigationLink("\(information.serviceName)" ) {
                                    DetailView(information: information)
                                }
                                
                            }
                        }
                    }
                }
                
                Text("\(information.pageNumbers)")
                
                
                Picker("종목", selection: $dddd) {
                    
                    ForEach(SportName.allCases, id:\.self) { information in
                        Text("\(information.rawValue)").tag(information)
                    }
                    
                    
                }
                
                Picker("지역", selection: $abcd) {
                    
                    ForEach(information.placeName2, id: \.self) { information in
                        
                        
                        Text(information)
                        
                        
                    }
                }
                
                
            }
            .onAppear {
                Task{
                    await information.getData(sportName: dddd.rawValue)
                    placeInformation = information.store[0].ListPublicReservationSport.resultDetails.filter{ $0.areaName == abcd
                    }
                }
            }
            
            .onChange(of: dddd.rawValue ) { _ in
                Task {
                    await information.getData(sportName: dddd.rawValue)
                    
                    placeInformation = information.store[0].ListPublicReservationSport.resultDetails.filter{ $0.areaName == abcd
                    }
                }
            }
            .onChange(of:abcd ) { _ in
                placeInformation = information.store[0].ListPublicReservationSport.resultDetails.filter{ $0.areaName == abcd
                }
            }
        }
    }
}



#Preview {
    HomeView()
}
