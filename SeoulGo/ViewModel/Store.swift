//
//  Store.swift
//  SeoulGo
//
//  Created by kaikim on 1/26/24.
//

import Foundation

@MainActor
class Store: ObservableObject {
    
    @Published var storeManager:[Row] = []
    @Published var favoriteLists:[Row] = []
    //@Published var selectedResults:[Row] = []
    @Published var allSports:[String] = []
    @Published var finalInformation:[Row] = []
    @Published var availableArea:[String] = []
    
    // section에서 같은 지역을 한꺼번에 묶어서 화면에 보여주기 위해서.
    @Published var areaDictionary:[String: [Row]] = [:]
    
    //Network Fetch 하는 함수
    @discardableResult
    func fetchRequest() async-> [Row] {
        let tempStore = await Network.getData()
        guard let row = tempStore.first else {
            return [] }
        storeManager = row.ListPublicReservationSport.resultDetails.sorted {$0.areaName < $1.areaName}
        finalInformation = storeManager
        availableArea = ["지역선택"]
        return storeManager
    }
    
    func getSelectedSports() {
        allSports = storeManager.map({ $0.minClass })
    }
    
    //HomeView에서 체육종목 선택 완료후 지역정보 보여주기
    @discardableResult
    func getSelectedSport(sport:String, areaName:String) -> [Row]{
       //스크롤 처음부터 시작하기 , 지금은 내린곳에서 변경됨, 다시안올라감
        if sport == "전체종목" {
            finalInformation = storeManager
            availableArea = ["지역선택"]
            return finalInformation
        }
        finalInformation = storeManager.filter{ $0.minClass == sport}
        availableArea = Array(Set(finalInformation.map { $0.areaName}))
        if availableArea.contains(areaName) {
            finalInformation = storeManager.filter { $0.minClass == sport && $0.areaName == areaName }
        }
        availableArea.insert("전체지역", at: 0)
        
        return finalInformation
    }
    
    //HomeView에서 체육종목,지역 선택 완료한 체육시설 정보 보여주기
    func getSelectedResults(sport:String, areaName:String){
       
        finalInformation = storeManager.filter { $0.minClass == sport && $0.areaName == areaName }
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
