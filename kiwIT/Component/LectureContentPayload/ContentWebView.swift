//
//  ContentWebView.swift
//  kiwIT
//
//  Created by Heedon on 6/24/24.
//

import SwiftUI

import WebKit

struct WebViewSetup: UIViewRepresentable {
    
    @Binding var isLoading: Bool
    var urlString: String
    
    //Navigation Delegate, manage loading state
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewSetup
        
        init(parent: WebViewSetup) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
            parent.isLoading = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlString) else {
            return WKWebView()
        }
        
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
      
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //
    }
    
//    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebViewSetup>) {
//        guard let url = URL(string: urlString) else { return }
//        webView.load(URLRequest(url: url))
//    }

}
