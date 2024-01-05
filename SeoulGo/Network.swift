//
//  Network.swift
//  SeoulGo
//
//  Created by kaikim on 1/4/24.
//

import Foundation

class Network: ObservableObject {
    
    
    private let apiKey = "647879614473646636395064566e6a"
    
    @Published var store:[SeoulDataModel] = []
    @Published var pageNumbers:Int = 0
    
    func getData(sportName:String) async {
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/json/ListPublicReservationSport/1/300/\(sportName)"
        guard let url = URL(string: urlString) else { return print(URLError.errorDomain)}
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
//            print("data = \(data), stringData = \(String(data: data, encoding: .utf8) ?? "Nothing to print")")
            
            let finalData = try JSONDecoder().decode(SeoulDataModel.self, from: data)
            pageNumbers = finalData.ListPublicReservationSport.listTotalCount
            print(pageNumbers)
            store.append(finalData)
            //print(store[0].ListPublicReservationSport.resultDetails)
        } catch {
            debugPrint("\(String(describing: error))")
            
        }
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
//    
