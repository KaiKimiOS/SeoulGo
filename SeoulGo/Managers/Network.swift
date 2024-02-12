//
//  Network.swift
//  SeoulGo
//
//  Created by kaikim on 1/4/24.
//

import SwiftUI

class Network {
        
    private init() { }
    
    @MainActor
    static func getData() async  -> [SeoulDataModel] {
        
        let apiKey = "647879614473646636395064566e6a"
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

}
