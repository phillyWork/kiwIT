//
//  CustomWebView.swift
//  kiwIT
//
//  Created by Heedon on 7/6/24.
//

import SwiftUI
import WebKit

struct SimpleWebView: UIViewRepresentable {
    
    var url: String
    private let webView = WKWebView()

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        
        if webView.url == nil {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {

    }
    
}
