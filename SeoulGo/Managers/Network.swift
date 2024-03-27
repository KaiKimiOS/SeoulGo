//
//  Network.swift
//  SeoulGo
//
//  Created by kaikim on 1/4/24.
//

import SwiftUI

final class Network {
    
    private init() { }
    deinit {
        print("deinit!!! in Network")
        
    }
    @MainActor
    static func getData() async throws -> [SeoulDataModel] {
        
        let apiKey = "647879614473646636395064566e6a"
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/json/ListPublicReservationSport/1/1000"
        
        guard let url = URL(string: urlString) else {
            throw SeoulGoError.noInternet
        }
      
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {throw SeoulGoError.serverError}
        guard let finalData = try? JSONDecoder().decode(SeoulDataModel.self, from: data) else {throw SeoulGoError.timeout}
        
        return [finalData]

    }
    
}
