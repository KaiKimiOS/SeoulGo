//
//  SeoulData.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import Foundation


struct SeoulDataModel: Decodable {
    
    let listTotalCount:Int
    let resultCode:String
    let resultMessage:String
    let areaName:String
    let playName:String
    let informationURL:String

    enum CodingKeys:String, CodingKey {
                case listTotalCount = "list_total_count"
                case resultCode = "RESULT.CODE"
//                case serviceID = "SVCID"
                case resultMessage = "RESULT.MESSAGE"
//                case gubun = "GUBUN"
//                case maxClass = "MAXCLASSNM"
//                case minClass = "MINCLASSNM"
//                case serviceStatus = "SVCSTATNM"
//                case serviceName = "SVCNM"
//                case payment = "PAYATNM"
                case playName = "PLACENM"
//                case useTarger = "USETGTINFO"
                case informationURL = "SVCURL"
                case areaName = "AREANM"
//                case serviceStartDate = "SVCOPNBGNDT"
//                case serviceEndDate = "SVCOPNENDDT"
//                case registerStartDate = "RCPTBGNDT"
//                case registerEndDate = "RCPTENDDT"
    }
}
