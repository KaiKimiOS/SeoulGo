//
//  WebKit.swift
//  SeoulGo
//
//  Created by kaikim on 1/11/24.
//

import SwiftUI
import WebKit


struct WebKit: UIViewRepresentable {

    
    var webURL:String
    
    func makeUIView(context: Context) -> some WKWebView {
        guard let url = URL(string: webURL) else { return WKWebView()}
        let webView  = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let url = URL(string: webURL) else { return }
        uiView.load(URLRequest(url: url))
    }
    
    
}
