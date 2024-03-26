//
//  Enum.swift
//  SeoulGo
//
//  Created by kaikim on 1/6/24.
//

import SwiftUI

enum SeoulGoError:Error {
    case InternetDisconnected
}

enum SportName:String, CaseIterable {
    case 전체종목 = "전체종목"
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

enum AreaName:String,CaseIterable {
    
    case 전체지역 = "전체지역"
    case 강남구 = "강남구"
    case 강동구 = "강동구"
    case 강서구 = "강서구"
    case 광진구 = "광진구"
    case 구로구 = "구로구"
    case 동대문구 = "동대문구"
    case 동작구 = "동작구"
    case 마포구 = "마포구"
    case 서초구 = "서초구"
    case 성동구 = "성동구"
    case 성북구 = "성북구"
    case 송파구 = "송파구"
    case 양천구 = "양천구"
    case 영등포구 = "영등포구"
    case 용산구 = "용산구"
    case 종로구 = "종로구"
    case 중구 = "중구"
    case 고양시 = "고양시"
    case 과천시 = "과천시"
    
}

extension String {
    func stringToDate() -> String {

        let firstDateFormatter = DateFormatter()
        firstDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let firstDate = firstDateFormatter.date(from: self)

        firstDateFormatter.dateFormat = "yyyy-MM-dd"
        firstDateFormatter.locale = Locale(identifier: "ko-KR")
        let secondDate = firstDateFormatter.string(from: firstDate!)

        return secondDate
    }

}

struct detailMoidifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .minimumScaleFactor(0.1)
            .foregroundStyle(.primary)
            .font(.system(size: 15, weight: .regular, design: .default))
    }
}


extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.kaikim.SeoulGo"
        guard let appGroup = UserDefaults(suiteName: appGroupId) else {
            print("AppGroup Error!")
            return UserDefaults() }
        return appGroup
    }
}
