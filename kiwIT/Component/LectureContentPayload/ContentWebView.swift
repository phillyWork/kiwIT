//
//  ContentWebView.swift
//  kiwIT
//
//  Created by Heedon on 6/24/24.
//

import SwiftUI

import WebKit

struct WebViewSetup: UIViewRepresentable {
        
    var urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlString) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
                     
    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebViewSetup>) {
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }

}
