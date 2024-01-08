//
//  Network.swift
//  SeoulGo
//
//  Created by kaikim on 1/4/24.
//

import Foundation
import SwiftSoup
class Network: ObservableObject {
    
    
    private let apiKey = "647879614473646636395064566e6a"
    
    @Published var store:[SeoulDataModel] = []
    @Published var pageNumbers:Int = 0
    
    @MainActor
    func getData(sportName:String) async {
        store.removeAll()
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/json/ListPublicReservationSport/1/300/\(sportName)"
        guard let url = URL(string: urlString) else { return print(URLError.errorDomain)}
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            //            print("data = \(data), stringData = \(String(data: data, encoding: .utf8) ?? "Nothing to print")")
            
            let finalData = try JSONDecoder().decode(SeoulDataModel.self, from: data)
            pageNumbers = finalData.ListPublicReservationSport.listTotalCount
            print(pageNumbers)
            
            store.append(finalData)
            
            
        } catch {
            debugPrint("\(String(describing: error))")
            
        }
        
        
        
        
    }
    @MainActor
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
