//
//  SFSafariView.swift
//  SeoulGo
//
//  Created by kaikim on 1/11/24.
//

import SwiftUI
import SafariServices

struct SFSafariView: UIViewControllerRepresentable {
    
    let officialURL:String =  "https://yeyak.seoul.go.kr/web/main.do"
    var url:String
    
    func makeUIViewController(context: Context) -> some SFSafariViewController {
       
        guard let url = URL(string: url) else { return SFSafariViewController(url: URL(string: officialURL)!) }
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        guard let url = URL(string: url) else { return }
        SFSafariViewController(url: url)
    }
}
