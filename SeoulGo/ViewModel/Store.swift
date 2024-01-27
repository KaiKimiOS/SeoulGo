//
//  Store.swift
//  SeoulGo
//
//  Created by kaikim on 1/26/24.
//

import Foundation

@MainActor
class Store: ObservableObject {
    
    private let network = Network.shared
    
    @Published var storeManager:[Row] = []
    @Published var favoriteLists:[Row] = []
    @Published var selectedResults:[Row] = []
    @Published var allSports:[String] = []
    @Published var allArea:[String] = []
    
    // section에서 같은 지역을 한꺼번에 묶어서 화면에 보여주기 위해서.
    @Published var areaDictionary:[String: [Row]] = [:]
    
    //Network Fetch 하는 함수
    func fetchRequest() async-> [Row] {
        let tempStore = await network.getData()
        guard let row = tempStore.first else {
            return [] }
        storeManager = row.ListPublicReservationSport.resultDetails
        return storeManager
    }
    
    func getSelectedSports() {
        allSports = storeManager.map({ $0.minClass })
    }
    
    //HomeView에서 체육종목 선택 완료후 지역정보 보여주기
    func getSelectedArea(sport:String) {
        let selectedArea = storeManager.filter{ $0.minClass == sport}.map {$0.areaName}
        allArea = Array(Set(selectedArea)).sorted(by: <)
    }
    
    //HomeView에서 체육종목,지역 선택 완료한 체육시설 정보 보여주기
    func getSelectedResults(sport:String, areaName:String) -> [Row] {
        selectedResults = storeManager.filter { $0.minClass == sport && $0.areaName == areaName }
        return selectedResults
    }
    
    //FavoriteView , UserDefaults.shared에 저장되어있는 값 가져오기
    func putUserDefaultsToLists() {
        
        favoriteLists = storeManager.filter { row in
            UserDefaults.shared.dictionaryRepresentation().keys.contains(row.serviceID)
        }
    }
    
    //FavoriteView, Dictionary해서 Area 묶어서 보여주기
    func putlistToDictionary() {
        
        areaDictionary = Dictionary(grouping: favoriteLists){ $0.areaName }
        // network.favoriteLists를 $0.areaName을 키값으로 해서 그룹핑해준다.
    }
    
}
