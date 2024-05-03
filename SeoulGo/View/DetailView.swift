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
    @State private var isStarClicked:Bool = false
    @State private var isWebViewButtonClicked: Bool = false
    @State private var isNaverMapButtonClicked:Bool = false
    @State private var isToastAlertClicked: Bool = false
    @State private var mainImage: Image?
   
    var information:Row
   
    private var locationY: Double {
        guard let locationY = Double(information.locationY) else { return 0 }
        return locationY
    }
    
    private var locationX: Double {
        guard let locationX = Double(information.locationX) else { return 0 }
        return locationX
    }
    
    private var star:String {
        isStarClicked ? "star.fill" : "star"
    }
    private var starDescription:String {
        isStarClicked ? "즐겨찾기에 저장되었습니다" : "저장이 취소되었습니다"
    }
    private var colorBasedOnColorScheme:Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            
            VStack(alignment:.leading,spacing: 10) {
                
                HeaderImageView
                MainTitleView
                TotalButtonView
                NaverMapView
                DetailInformationView
                GoogleBannerView
                
            }
            .padding()
            .sheet(isPresented: $isWebViewButtonClicked, content: {
                SFSafariView(url: information.informationURL)
            })
            .modifier(ToastAlertModifier(isPresented: $isToastAlertClicked, title: starDescription))
            .task {
                do{
                    self.mainImage = try await cachedImage(urlString: information.imageURL)
                }catch {
                    self.mainImage = Image(systemName: "xmark")
                    print("error in Image")
                }
            }
            .onAppear {
            
                isNaverMapButtonClicked = true
                checkingFavoriteList(id: information.serviceID)
            }
            .onDisappear {
                isNaverMapButtonClicked = false
            }
        }
        
    }
    
    
    func cachedImage(urlString:String) async throws -> Image {
        
        guard let url = URL(string: urlString) else {throw URLError(.badURL)}
        let urlRequest = URLRequest(url: url)

        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            guard let image = UIImage(data: cachedResponse.data) else { return Image(systemName: "xmark")}
            return Image(uiImage: image)
        }  else {
            let (data, response ) = try await URLSession.shared.data(from: url)
            URLCache.shared.storeCachedResponse(CachedURLResponse(response: response, data: data), for: urlRequest)
            guard let image = UIImage(data: data) else { return Image(systemName: "xmark")}
            return Image(uiImage: image)
        }
    }
    
    func checkingFavoriteList(id:String)  {
        
        if UserDefaults.shared.value(forKey: id) as? String == id {
            isStarClicked = true
        } else {
            isStarClicked = false
        }
    }
    
    func savedButton() {
        toastAlert()
        isStarClicked ? savedToUserDefaults(id: information.serviceID)
        : deletedToUserDefaults(id: information.serviceID)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func toastAlert() {
        isToastAlertClicked.toggle()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isToastAlertClicked = false
        }
    }
    
    func savedToUserDefaults(id:String) {
        UserDefaults.shared.setValue(id, forKey: id)
    }
    
    func deletedToUserDefaults(id:String) {
        UserDefaults.shared.removeObject(forKey: id)
    }
    
    func makePhoneCall() {
        if let phoneURL = URL(string: "tel://\(information.telephone.replacingOccurrences(of: "-", with:""))"), UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL)
        }
    }
    
    func goToNaverMapAPP(lat: Double, lng: Double) {
        // 자동차 길찾기 + 도착지 좌표 + 앱 번들 id
        //    guard let url = URL(string: "nmap://route/car?dlat=\(lat)&dlng=\(lng)&appname=kaikim.SeoulGo") else { return }
        guard let url = URL(string: "nmap://map?lat=\(lat)&lng=\(lng)&zoom=15&appname=kaikim.SeoulGo") else { return }
        
        //        guard let url = URL(string: "nmap://map?&appname=kaikim.SeoulGo") else { return }
        // 네이버지도 앱스토어 url
        guard let appStoreURL = URL(string: "http://itunes.apple.com/app/id311867728?mt=8") else { return }
        
        UIApplication.shared.canOpenURL(url) ? UIApplication.shared.open(url) :  UIApplication.shared.open(appStoreURL)
    }

    
    @ViewBuilder
    private var HeaderImageView: some View {
        VStack {
        
                
            if let mainImage {
                mainImage
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .frame(maxWidth: .infinity, minHeight: 182, idealHeight: 182, maxHeight: 182,alignment: .center)

    }
    
    @ViewBuilder
    private var MainTitleView: some View {
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
    private var WebsiteButtonView: some View {
        
        VStack{
            Button {
                isWebViewButtonClicked = true
            } label: {
                VStack(spacing: 5){
                    Image(systemName: "calendar")
                    Text("예약 사이트")
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var StarButtonView: some View {
        VStack{
            Button {
                
                isStarClicked.toggle()
                savedButton()
                
            } label: {
                VStack(spacing: 5){
                    Image(systemName: star)
                    Text("저장")
                }
                .foregroundStyle(isStarClicked ? .blue : .gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var ShareButtonView: some View {
        
        VStack {
            
            ShareLink(item: URL(string: information.informationURL)!) {
                VStack(spacing: 5){
                    
                    Image(systemName: "square.and.arrow.up")
                    Text("공유")
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    private var TotalButtonView: some View {
        HStack {
            WebsiteButtonView
            
            Divider()
                .frame(height: 64)
            StarButtonView
            
            Divider()
                .frame(height: 64)
            ShareButtonView
            
        }
        .foregroundStyle(.gray)
        
    }
    
    @ViewBuilder
    private var NaverMapView: some View {
        
        
        ZStack(alignment:.topTrailing) {
            
            
            if isNaverMapButtonClicked {
                NaverMapWithSnapShot(x: locationX, y: locationY)
                    .frame(maxWidth: .infinity, minHeight: 162)
                
            }
            
            NavigationLink{
                NaverMapWithNavigationLink(x: locationX, y: locationY)
                    .toolbar {
                        ToolbarItem(placement:.topBarTrailing) {
                            
                            Button {
                                goToNaverMapAPP(lat: locationY, lng: locationX)
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
    private var DetailInformationView: some View {
        
        
        VStack(alignment:.leading, spacing: 10){
            Text("주소          " + "\(information.areaName)" + " - \(information.placeName)" ).lineLimit(1)
            
            Text("접수상태    " + "\(information.serviceStatus)" + "(\(information.payment))")
            
            Text("접수기간    " + "\(information.registerStartDate.stringToDate())" + " ~ \(information.registerEndDate.stringToDate())")
            
            if information.telephone != "" {
                HStack(spacing: 15) {
                    Text("전화번호")
                    Text("\(information.telephone)")
                        .foregroundStyle(information.telephone.contains(" ") ? colorBasedOnColorScheme : .blue)
                        .onTapGesture {
                            makePhoneCall()
                        }
                }
            }
        }
        .modifier(detailMoidifier())
    }
    
    @ViewBuilder
    private var GoogleBannerView: some View{
        HStack(alignment:.center){
            GoogleBanner()
        }
    }
    
    
    
    //        func reverseGeo(lat:Double, lng:Double) async -> [ReverseGeoModel] {
    //            let clientId:String = "2lm2knho6r"
    //            let clientSecret:String = "KN3UDAq2bPAcOjOFkLoEPpijfOOvphn8g26BjeBb"
    //
    //
    //            let coords = "\(lat),\(lng)"
    //            let output = "json"
    //            let orders = "addr,admcode,roadaddr"
    //            let endpoint = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc"
    //
    //            let url = "\(endpoint)?coords=\(coords)&orders=\(orders)&output=\(output)"
    //
    //
    //            let headers: [String: String] = [
    //                "X-NCP-APIGW-API-KEY-ID": clientId,
    //                "X-NCP-APIGW-API-KEY": clientSecret,
    //            ]
    //
    //            guard let url1 = URL(string: url) else {
    //
    //                print(coords)
    //                print(URLError.errorDomain)
    //                print("2️⃣")
    //                return []}
    //
    //            do {
    //                print(url1)
    //                print(coords)
    //                var urlRequest = URLRequest(url: url1)
    //                urlRequest.setValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
    //                urlRequest.setValue(clientId, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
    //                //
    //                print(urlRequest.allHTTPHeaderFields)
    //                //            urlRequest.allHTTPHeaderFields = headers
    //                let (data,response) = try await URLSession.shared.data(for: urlRequest)
    //                guard let httpresponse = response as? HTTPURLResponse, (200...299).contains(httpresponse.statusCode) else {
    //                    print(URLError.errorDomain)
    //                    print(URLError.badServerResponse)
    //                    print(URLError.badURL)
    //                    print("3️⃣")
    //                    return []
    //                }
    //
    //                let finalData = try JSONDecoder().decode(ReverseGeoModel.self, from: data)
    //                return [finalData]
    //            } catch {
    //                debugPrint("4️⃣\(String(describing: error))")
    //            }
    //            return []
    //        }
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
