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
    
    
    
    func fectRequest() async-> [Row] {
        let tempStore = await network.getData()
        
        guard let row = tempStore.first else {
            return []}
        storeManager = row.ListPublicReservationSport.resultDetails
        return storeManager
    }
    
    func getSelectedSports() {
        allSports = storeManager.map({ $0.minClass })
            
        
    }
    
    func getSelectedArea(sport:String) {
       let selectedArea = storeManager.filter{ $0.minClass == sport}.map {$0.areaName}
        allArea = Array(Set(selectedArea))
    }
    
    func getSelectedResults(sport:String, areaName:String) -> [Row] {
        selectedResults = storeManager.filter { $0.minClass == sport && $0.areaName == areaName }
        return selectedResults
    }
}
