//
//  SeoulData.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import Foundation


struct SeoulDataModel:Decodable{
    
    let ListPublicReservationSport:ListPublicReservationSport
}

struct ListPublicReservationSport:Decodable{
    
    let listTotalCount:Int
    let result:Result1
    let resultDetails:[Row]
    
    enum CodingKeys:String, CodingKey {
        case listTotalCount = "list_total_count"
        case result = "RESULT"
        case resultDetails = "row"
    }
}

struct Result1:Decodable {
    let code: String
    let message:String
    
    enum CodingKeys: String, CodingKey {
        case code = "CODE"
        case message = "MESSAGE"
    }
}

struct Row: Decodable {
    
    let gubun:String
    let serviceID,
        maxClass,
        minClass,
        serviceStatus,
        serviceName,
        payment,
        placeName,
        userTarget,
        informationURL,
        serviceStartDate,
        serviceEndDate,
        registerStartDate,
        registerEndDate,
        areaName,
        telephone,
        imageURL:String
    let locationX:String
    let locationY:String
    
    enum CodingKeys: String, CodingKey {
        case gubun = "GUBUN"
        case serviceID = "SVCID"
        case maxClass = "MAXCLASSNM"
        case minClass = "MINCLASSNM"
        case serviceStatus = "SVCSTATNM"
        case serviceName = "SVCNM"
        case payment = "PAYATNM"
        case placeName = "PLACENM"
        case userTarget = "USETGTINFO"
        case informationURL = "SVCURL"
        case locationX = "X"
        case locationY = "Y"
        case serviceStartDate = "SVCOPNBGNDT"
        case serviceEndDate = "SVCOPNENDDT"
        case registerStartDate = "RCPTBGNDT"
        case registerEndDate = "RCPTENDDT"
        case areaName = "AREANM"
        case telephone = "TELNO"
        case imageURL = "IMGURL"
    }
    
}
