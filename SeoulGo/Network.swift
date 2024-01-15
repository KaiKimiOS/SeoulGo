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
    @Published var favoriteLists:[Row]? = []
    @Published var totalSports:[Row] = []
    @Published var pageNumbers:Int = 0
    @Published var finalSportLists:[Row] = []

    @Published var placeArea:[String] = []
    
    @MainActor
    func getData() async {
        
        store.removeAll()
        placeArea.removeAll()
        
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/json/ListPublicReservationSport/1/1000"
        
        guard let url = URL(string: urlString) else { return print(URLError.errorDomain)}
        
        do {
            
            let (data,_) = try await URLSession.shared.data(from: url)
            let finalData = try JSONDecoder().decode(SeoulDataModel.self, from: data)
            
            pageNumbers = finalData.ListPublicReservationSport.listTotalCount
            
            store.append(finalData)
//            getSportName(sportName: "축구장")
//            getArea(areaName: "송파구")
            
        } catch {
            debugPrint("\(String(describing: error))")
            
        }
   
    }
    
    func getSportName(sportName:String) {
        totalSports.removeAll()
        placeArea.removeAll()
        totalSports = (store.first?.ListPublicReservationSport.resultDetails.filter{ $0.minClass == sportName})!
        placeArea = Array(Set((store.first?.ListPublicReservationSport.resultDetails.map { $0.areaName })!)).sorted(by: <)
        
    }
    func getArea(areaName:String) {
        finalSportLists.removeAll()
        finalSportLists = totalSports.filter { $0.areaName ==  areaName}
//        print(finalSportLists)
        
    }
//    func toStar(serviceID:String) {
//        var selectedID = (store.first?.ListPublicReservationSport.resultDetails.filter{ $0.serviceID == serviceID })!
//        selectedID[0].star.toggle()
//    }
    
    //SwiftSoup
//    func temptemp() async {
//        
//      
//        let urlAddress = "https://yeyak.seoul.go.kr/web/reservation/selectReservView.do?rsv_svc_id=S210401100008601453"
//        
//        guard let url2 = URL(string: urlAddress) else {return}
//        do {
//            let (data,_) = try await URLSession.shared.data(from: url2)
//            guard let html = String(data: data, encoding: .utf8) else { return }
//            
//            let doc: Document = try SwiftSoup.parse(html)
//            let title = try doc.select("#cal_20240116").select("a") // 클래스 ".tit1" , 세부항목 "b"
//            print(try title.text())
//            
//        }
//        catch {
//            
//            print(error.localizedDescription)
//            
//        }
//    }
    
}
