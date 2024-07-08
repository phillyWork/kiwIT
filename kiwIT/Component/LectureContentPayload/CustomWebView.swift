//
//  ContentWebView.swift
//  kiwIT
//
//  Created by Heedon on 6/24/24.
//

import SwiftUI

import WebKit

struct CustomWebView: UIViewRepresentable {
    
    @Binding var isLoading: Bool
    var urlString: String
    
    //Navigation Delegate, manage loading state
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: CustomWebView
        
        init(parent: CustomWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("Webview started provisional navigation")
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Webview finished navigation")
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
            print("Webview failed navigation with error: \(error.localizedDescription)")
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: any Error) {
            print("Webview failed provisional navigation with error: \(error.localizedDescription)")
            parent.isLoading = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        print("make webview")
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            return WKWebView()
        }
        
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
      
    func updateUIView(_ webView: WKWebView, context: Context) {

    }
}
