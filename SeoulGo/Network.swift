//
//  Network.swift
//  SeoulGo
//
//  Created by kaikim on 1/4/24.
//


import SwiftSoup
import SwiftUI
class Network: ObservableObject {
    
    
    private let apiKey = "647879614473646636395064566e6a"
    
    @Published var store:[SeoulDataModel] = []
    @Published var pageNumbers:Int = 0
    @Published var placeName:Set<String> = []
    @Published var placeName2:[String] = []
    
    @MainActor
    func getData(sportName:String) async {
        store.removeAll()
        placeName.removeAll()
        placeName2.removeAll()
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/json/ListPublicReservationSport/1/300/\(sportName)"
        guard let url = URL(string: urlString) else { return print(URLError.errorDomain)}
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
//             print("data = \(data), stringData = \(String(data: data, encoding: .utf8) ?? "Nothing to print")")
            
            let finalData = try JSONDecoder().decode(SeoulDataModel.self, from: data)
            pageNumbers = finalData.ListPublicReservationSport.listTotalCount
            var area =  finalData.ListPublicReservationSport.resultDetails.map { $0.areaName}
          
            for i in 0..<area.count {
                placeName.insert(area[i])
            }
            for i in placeName {
                placeName2.append(i)
            }

            placeName2.sort(by: <)
           
            
            store.append(finalData)
            // 구장에 따른 지역 출력
            
            
        } catch {
            debugPrint("\(String(describing: error))")
            
        }
        
        
        
        
    }

    //SwiftSoup
    func temptemp() async {

        let urlAddress = "https://yeyak.seoul.go.kr/web/reservation/selectReservView.do?rsv_svc_id=S210401100008601453"
        
        guard let url2 = URL(string: urlAddress) else {return}
        do {
            let (data,_) = try await URLSession.shared.data(from: url2)
            guard let html = String(data: data, encoding: .utf8) else { return }
            
            let doc: Document = try SwiftSoup.parse(html)
            let title = try doc.select(".tit1").select("b") // 클래스 ".tit1" , 세부항목 "b"
            print(try title.text())
            
        }
        catch {
            
            print(error.localizedDescription)
            
        }
    }
    
}
