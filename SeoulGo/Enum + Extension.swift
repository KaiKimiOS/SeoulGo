//
//  Enum.swift
//  SeoulGo
//
//  Created by kaikim on 1/6/24.
//

import SwiftUI


enum SportName:String, CaseIterable {
    case 전체 = ""
    case 축구 = "축구장"
    case 농구 = "농구장"
    case 풋살 = "풋살장"
    case 테니스 = "테니스장"
    case 족구 = "족구장"
    case 야구 = "야구장"
    case 배드민턴 = "배드민턴장"
    case 배구 = "배구장"
    case 다목적경기장 = "다목적경기장"
}

extension String {
    func stringToDate() -> String {
        
        let firstDateFormatter = DateFormatter()
        firstDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let firstDate = firstDateFormatter.date(from: self)
        
        let secondDateFormatter = DateFormatter()
        secondDateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        secondDateFormatter.locale = Locale(identifier: "ko-KR")
        let secondDate = secondDateFormatter.string(from: firstDate!)
        
        return secondDate
    }
    
}

struct detailMoidifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 17)
            .background(.clear)
            .frame(minWidth: 0, maxWidth: .infinity)
            .cornerRadius(20.0)
            .overlay(RoundedRectangle(cornerRadius: 20.0)
                .stroke(Color(.lightGray), lineWidth: 1))
            .padding(.top, 8)
            .minimumScaleFactor(0.1)
          
    }
}
