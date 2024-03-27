//
//  DetailView.swift
//  SeoulGo
//
//  Created by kaikim on 1/9/24.
//

import SwiftUI
import NMapsMap
import SafariServices
import GoogleMobileAds
import WidgetKit


struct DetailView:View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var starBool:Bool = false
    @State private var isWebViewBool: Bool = false
    @State private var isNaverMapBool:Bool = false
    @State private var isToastAlertBool: Bool = false
    
    var information:Row
    
    private var imageURL: URL? {
        URL(string: information.imageURL)
    }
    
    private var locationY: Double {
        guard let locationY = Double(information.locationY) else { return 0 }
        return locationY
    }
    
    private var locationX: Double {
        guard let locationX = Double(information.locationX) else { return 0 }
        return locationX
    }
    
    private var star:String {
        starBool ? "star.fill" : "star"
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment:.leading,spacing: 10) {
                
                HeadImageView()
                MainTitleView()
                ButtonView()
                NaverMapView()
                DetailInformationView()
                BannerView()
                
            }
            .padding()
            
            .sheet(isPresented: $isWebViewBool, content: {
                SFSafariView(url: information.informationURL)
            })
            .modifier(ToastAlertModifier(isPresented: $isToastAlertBool, title: starBool ? "즐겨찾기에 저장되었습니다." : "저장이 삭제되었습니다."))
            .onAppear {
                
                isNaverMapBool = true
                checkingFavorite(id: information.serviceID)
                  
            }
            
            .onDisappear {
                isNaverMapBool = false
            }
        }
        
        
        
    }
    
    func checkingFavorite(id:String)  {
        if UserDefaults.shared.value(forKey: "\(information.serviceID)") as? String ?? "" == information.serviceID {
            return starBool = true
        } else {
            starBool = false
        }
        
    }
    
    @ViewBuilder
    func HeadImageView() -> some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .frame(maxWidth: .infinity, minHeight: 182, idealHeight: 182, maxHeight: 182)
        } placeholder: {
            ProgressView()
        }
    }
    
    @ViewBuilder
    func MainTitleView() -> some View {
        VStack(alignment: .center){
            Text("\(information.serviceName)")
                .bold()
                .lineLimit(1)
                .frame(maxWidth:.infinity)
                .font(.system(size: 18, weight: .bold, design: .default ))
                .padding([.bottom,.top])
            Divider()
        }
    }
    
    @ViewBuilder
    func ButtonView() -> some View {
        HStack {
            VStack{
                Button {
                    isWebViewBool = true
                } label: {
                    VStack(spacing: 5){
                        Image(systemName: "calendar")
                        Text("예약 사이트")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 64)
            VStack{
                Button {
                    starBool.toggle()
                    isToastAlertBool.toggle()
                    starBool ?  UserDefaults.shared.setValue(information.serviceID, forKey: information.serviceID) :
                    UserDefaults.shared.removeObject(forKey: information.serviceID)
                    WidgetCenter.shared.reloadAllTimelines()
                    
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        isToastAlertBool = false
                    }
                } label: {
                    VStack(spacing: 5){
                        Image(systemName: star)
                        Text("저장")
                    }
                    .foregroundStyle(starBool ? .blue : .gray)
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
                .frame(height: 64)
            VStack {
                ShareLink(item:  URL(string: information.informationURL)!) {
                    VStack(spacing: 5){
                        
                        Image(systemName: "square.and.arrow.up")
                        Text("공유")
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
        }
        .foregroundStyle(.gray)
        
    }
    func NaverMapView() -> some View {
        
        ZStack(alignment:.topTrailing) {
            
            
            if isNaverMapBool {
                NaverMapWithSnapShot(x: locationX, y: locationY)
                    .frame(maxWidth: .infinity, minHeight: 162)
                
            }
            
            NavigationLink{
                NaverMapWithNavigationLink(x: locationX, y: locationY)
                    .toolbar {
                        ToolbarItem(placement:.topBarTrailing) {
                            
                            Button {
                                showNaverMap(lat: locationY, lng: locationX)
                            } label: {
                                Text("네이버지도")
                                Image(systemName: "map")
                                
                            }
                            
                            
                        }
                    }
            } label: {
                Image(systemName: "arrow.down.backward.and.arrow.up.forward.square.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundStyle(Color.gray.opacity(0.5))
                    .frame(width: 30, height: 30)
                    .padding(10)
            }
        }
        
        
    }
    @ViewBuilder
    func DetailInformationView() -> some View {
        
        
        VStack(alignment:.leading, spacing: 10){
            Text("주소          " + "\(information.areaName)" + " - \(information.placeName)" ).lineLimit(1)
            
            Text("접수상태    " + "\(information.serviceStatus)" + "(\(information.payment))")
            
            Text("접수기간    " + "\(information.registerStartDate.stringToDate())" + " ~ \(information.registerEndDate.stringToDate())")
            
            if information.telephone != "" {
                HStack(spacing: 15){
                    Text("전화번호")
                    Text("\(information.telephone)")
                        .foregroundStyle(information.telephone.contains(" ") ? colorScheme == .dark ? .white : .black : .blue)
                        .onTapGesture {
                            makePhoneCall()
                        }
                }
            }
        }
        .modifier(detailMoidifier())
        
        
    }
    @ViewBuilder
    func BannerView() -> some View {
        HStack(alignment:.center){
            GoogleBanner()
            
        }
        
    }
    
    func makePhoneCall() {
        if let phoneURL = URL(string: "tel://\(information.telephone.replacingOccurrences(of: "-", with:""))"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL)
        }
        
    }
    func showNaverMap(lat: Double, lng: Double) {
        // 자동차 길찾기 + 도착지 좌표 + 앱 번들 id
        //    guard let url = URL(string: "nmap://route/car?dlat=\(lat)&dlng=\(lng)&appname=kaikim.SeoulGo") else { return }
        guard let url = URL(string: "nmap://map?lat=\(lat)&lng=\(lng)&zoom=15&appname=kaikim.SeoulGo") else { return }
        
        //        guard let url = URL(string: "nmap://map?&appname=kaikim.SeoulGo") else { return }
        // 네이버지도 앱스토어 url
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }
        
        // 네이버지도 앱이 존재 한다면,
        if UIApplication.shared.canOpenURL(url) {
            // 길찾기 open
            UIApplication.shared.open(url)
        } else { // 네이버지도 앱이 없다면,
            // 네이버지도 앱 설치 앱스토어로 이동
            UIApplication.shared.open(appStoreURL)
        }
    }
    
    func reverseGeo(lat:Double, lng:Double) async -> [ReverseGeoModel] {
        let clientId:String = "2lm2knho6r"
        let clientSecret:String = "KN3UDAq2bPAcOjOFkLoEPpijfOOvphn8g26BjeBb"
        
        
        let coords = "\(lat),\(lng)"
        let output = "json"
        let orders = "addr,admcode,roadaddr"
        let endpoint = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
        
        let url = "\(endpoint)?coords=\(coords)&orders=\(orders)&output=\(output)"
        
        
        let headers: [String: String] = [
            "X-NCP-APIGW-API-KEY-ID": clientId,
            "X-NCP-APIGW-API-KEY": clientSecret,
        ]
        
        guard let url1 = URL(string: url) else {
            
            print(coords)
            print(URLError.errorDomain)
            print("2️⃣")
            return []}
        
        do {
            print(url1)
            print(coords)
            var urlRequest = URLRequest(url: url1)
            urlRequest.setValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
            urlRequest.setValue(clientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
            //
            print(urlRequest.allHTTPHeaderFields)
            //            urlRequest.allHTTPHeaderFields = headers
            let (data,response) = try await URLSession.shared.data(for: urlRequest)
            guard let httpresponse = response as? HTTPURLResponse, (200...299).contains(httpresponse.statusCode) else {
                print(URLError.errorDomain)
                print(URLError.badServerResponse)
                print(URLError.badURL)
                print("3️⃣")
                return []
            }
            
            let finalData = try JSONDecoder().decode(ReverseGeoModel.self, from: data)
            return [finalData]
        } catch {
            debugPrint("4️⃣\(String(describing: error))")
        }
        return []
    }
}



//#Preview {
//    DetailView(information: Row(gubun: "구분", serviceID: "아이디", maxClass: "큰클래스", minClass: "작은클래스", serviceStatus: "상태", serviceName: "네임", payment: "ㄷ돈", placeName: "", userTarget: "1", informationURL: "1", locationX: "1", locationY: "1", serviceStartDate: "1", serviceEndDate: "1", registerStartDate: "1", registerEndDate: "1", areaName: "1", imageURL: "https://yeyak.seoul.go.kr/web/common/file/FileDown.do?file_id=1699407981833BDABH9JL28HPGSME2RMXBEFMX"))
//}

//BannerView()
//    .frame(width: 320, height: 50)
//    .border(.black)




//저장되면 토스트 메세지 "저장되었습니다"
//
//HStack(spacing: 15) {
//    Text("주소      ")
//    Text("\(information.areaName)" + " - \(information.placeName)" )
//
//}
//.modifier(detailMoidifier())
//
//HStack(spacing: 15){
//    Text("접수상태")
//    Text("\(information.serviceStatus)" + "(\(information.payment))")
//
//}
//.modifier(detailMoidifier())
//
//HStack(spacing: 15){
//
//    Text("접수기간")
//    Text("\(information.registerStartDate)" + " ~ \(information.registerEndDate)" )
//
//}
//.modifier(detailMoidifier())
//
//if information.telephone != "" {
//    HStack(spacing: 15){
//        Text("전화번호")
//        Text("\(information.telephone)")
//            .foregroundStyle(.blue)
//            .onTapGesture {
//                makePhoneCall()
//            }
//    }
//    .modifier(detailMoidifier())
//}
