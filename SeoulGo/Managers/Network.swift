//
//  Network.swift
//  SeoulGo
//
//  Created by kaikim on 1/4/24.
//

import SwiftUI

final class Network {
    
    //전역이기에 또 생성되게 함을 막아주기 위해서 private 접근제어 설정
    private init() { }
    
    deinit {
        print("deinit Network")
    }
    
    @MainActor
    static func getData() async throws -> [SeoulDataModel] {
        
        let apiKey = Bundle.main.infoDictionary?["APIKEY"] as! String
        let urlString = "http://openAPI.seoul.go.kr:8088/\(apiKey)/json/ListPublicReservationSport/1/1000"
        
        guard let url = URL(string: urlString) else {
            throw NetworError.noInternet
        }
      
        let (data,response) = try await URLSession.shared.data(from: url)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {throw NetworError.serverError}
        guard let finalData = try? JSONDecoder().decode(SeoulDataModel.self, from: data) else {throw NetworError.timeout}
        
        return [finalData]

    }
    
}
