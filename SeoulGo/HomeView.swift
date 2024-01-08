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
    @State var abcd:PlaceName = .송파구
    @State var dddd: SportName = .축구
    enum PlaceName:String, CaseIterable {
        case 전체 = "전체"
        case 송파구 = "송파구"
        case 강남구 = "강남구"
        case 강동구 = "강동구"
    }
    
    enum SportName:String, CaseIterable {
        case 전체 = "전체"
        case 축구 = "축구장"
        case 농구 = "농구장"
        case 풋살 = "풋살장"
    }
    //각 종목이 있는 지역이 있다. 그걸 나눠야함.
    //다른 문화시설도 다할지?
    // picker 바뀌면 자동으로 보여줄지? 지금은 버튼을 눌러야만 보여주니까
    // 종목별 enum처리
    // 지역별 enum처리
    var body: some View {
        VStack {
            
            List {
                if placeInformation.first == nil {
                    Text("구장과 지역을 선택해주세요")
                } else {
                    ForEach(placeInformation, id: \.serviceID) { information in
                        HStack{
                            Text(information.serviceName)
                            Text(",")
                            Text(information.serviceStatus)
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
            
                ForEach(PlaceName.allCases, id:\.self) { information in
                    Text("\(information.rawValue)").tag(information)
                }
       

            }
            
            
            Button{
                
                Task {
                    await information.getData(sportName: dddd.rawValue)
                    print(dddd)
                    placeInformation = information.store[0].ListPublicReservationSport.resultDetails.filter{ $0.areaName == abcd.rawValue   }

                    print(placeInformation.first)
                }
                
            } label: {
                Text("Button")
            }
            
            
//            Button{
//                print(abcd)
////                placeInformation = information.store[0].ListPublicReservationSport.resultDetails.filter{ $0.areaName == abcd.rawValue   }
//                print(placeInformation)
//            } label: {
//                Text("Button2")
//            }
//            .buttonStyle(.bordered)
            
            
        }
    }
    
    
    
}





#Preview {
    HomeView()
}
