//
//  HomeView.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var information = Network()
    
    @State var placeInformation: [Row] = []
    @State var abcd:PlaceName = .songpa
    enum PlaceName:String {
        case songpa = "송파구"
        case gangnam = "강남구"
    }
    
    // 종목별 enum처리
    // 지역별 enum처리
    var body: some View {
        VStack {
            
            List {
                //                ForEach(information.store, id: \.ListPublicReservationSport.listTotalCount){ info in
                //
                //                    ForEach(0..<information.pageNumbers) { i in
                //                        Text("\(i)" + "\(info.ListPublicReservationSport.resultDetails[i].placeName)")
                //                    }
                //
                //
                //
                //                }
                
                ForEach(placeInformation, id: \.serviceID) { information in
                    Text(information.serviceName)
                }
            }
            
            Text("\(information.pageNumbers)")
            
            Picker("픽픽", selection: $abcd) {
                Text("송파구").tag(PlaceName.songpa)
                Text("강남구").tag(PlaceName.gangnam)
            }
            Button{
                Task {
                    await information.getData(sportName: "축구장")
                    
                }
                
            } label: {
                Text("Button")
            }
            
            
            Button{
                placeInformation = information.store[0].ListPublicReservationSport.resultDetails.filter{ $0.areaName == "송파구"
                }
                print(placeInformation)
            } label: {
                Text("Button2")
            }
            .buttonStyle(.bordered)
            
            
        }
    }
    
    //    func requestData() {
    //        do{
    //            let decode = try JSONDecoder().decode(SeoulDataModel.self, from: dummy.data(using: .utf8)!)
    //            print(decode)
    //            dataList.append("\(decode.ListPublicReservationSport.resultDetails[0])")
    //
    //        } catch {
    //            print(error)
    //        }
    //    }
    
    
}





#Preview {
    HomeView()
}
