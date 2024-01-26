//
//  Network.swift
//  SeoulGo
//
//  Created by kaikim on 1/4/24.
//

import SwiftUI

class Network: ObservableObject {
    
    static let shared = Network()
    
    private init() { }
    
    private let apiKey = "647879614473646636395064566e6a"
    
//    @Published var store:[SeoulDataModel] = []
//    @Published var favoriteLists:[Row]? = []
//    @Published var totalSports:[Row] = []
//    @Published var pageNumbers:Int?
//    @Published var finalSportLists:[Row] = []
//    @Published var placeArea:[String] = []
    
    @MainActor
    func getData() async  -> [SeoulDataModel] {
        
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/json/ListPublicReservationSport/1/1000"

        guard let url = URL(string: urlString) else {
            print(URLError.errorDomain)
            return [] }
        do {
            let (data,_) = try await URLSession.shared.data(from: url)
            let finalData = try JSONDecoder().decode(SeoulDataModel.self, from: data)
            return [finalData]
        } catch {
            debugPrint("\(String(describing: error))")
        }
        
        return []
    }
    
//    func getSportName(sportName:String) {
//        totalSports.removeAll()
//        placeArea.removeAll()
//        
//        
//        
//        totalSports = (store.first?.ListPublicReservationSport.resultDetails.filter{ $0.minClass == sportName})!
//        placeArea = Array(Set((store.first?.ListPublicReservationSport.resultDetails.map { $0.areaName })!)).sorted(by: <)
//        
//    }
//    func getArea(areaName:String) {
//        finalSportLists.removeAll()
//        finalSportLists = totalSports.filter { $0.areaName ==  areaName}
////        print(finalSportLists)
//        
//    }
}
