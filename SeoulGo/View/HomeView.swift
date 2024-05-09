//
//  HomeView.swift
//  SeoulGo
//
//  Created by kaikim on 12/30/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var store: Store
    @State private var areaName: String = "전체지역"
    @State private var sportName: SportName = .전체종목
    
    var body: some View {
        
        NavigationStack{
            VStack(alignment:.leading,spacing:0) {
                
                HStack(spacing:0){
                    Picker("전체종목", selection: $sportName) {
                        ForEach(SportName.allCases, id:\.self) { information in
                            Text("\(information.rawValue)").tag(information)
                        }
                    }
                    
                    Picker("전체지역", selection: $areaName) {
                        ForEach(store.availableArea, id: \.self) { area in
                            Text(area).tag(area)
                        }
                    }
                }
                .padding(.leading,5)
                
                
                List {
                    ForEach(store.finalInformation, id: \.serviceID) { info  in
                        NavigationLink("\(info.serviceName)" ) {
                            DetailView(information: info)
                        }
                    }
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement:.topBarLeading) {
                    mainHeaderView
                }
            }
        }
        .alert(store.errorType?.errorTitle ?? "에러발생", isPresented: $store.hasError, actions: {
            Button("확인") { }
        }, message: {
            
            if let errorDescription = store.errorType?.errorDescription {
                Text(errorDescription)
            }
        })
        
        .refreshable {
            await store.fetchRequest()
        }
        .onChange(of: sportName.rawValue ) {
            store.getSelectedSport(sport: sportName.rawValue, areaName: areaName)
        }
        .onChange(of:areaName) {
            
            if areaName == "전체지역" || areaName == "지역선택" {
                store.getSelectedSport(sport: sportName.rawValue, areaName: areaName)
            } else {
                store.getSelectedResults(sport: sportName.rawValue, areaName: areaName)
            }
        }
    }
    
    private var mainHeaderView: some View {
        HStack {
            Image("HomeTitle")
                .resizable()
                .frame(width: 120, height: 23, alignment: .center)
            
            if store.storeManager.isEmpty {
                
                ProgressView()
                    .tint(Color.blue)
                    .padding()
            }
                
        }
    }
}
