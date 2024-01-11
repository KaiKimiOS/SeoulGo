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

    @Published var placeArea:[String] = []
    
    @MainActor
    func getData(sportName:String) async {
        
        store.removeAll()
        placeArea.removeAll()
        
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/json/ListPublicReservationSport/1/300/\(sportName)"
        
        guard let url = URL(string: urlString) else { return print(URLError.errorDomain)}
        
        do {
            
            let (data,_) = try await URLSession.shared.data(from: url)
            let finalData = try JSONDecoder().decode(SeoulDataModel.self, from: data)
            
            pageNumbers = finalData.ListPublicReservationSport.listTotalCount
            placeArea = Array(Set(finalData.ListPublicReservationSport.resultDetails.map { $0.areaName })).sorted(by: <)
            
            store.append(finalData)
            
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
