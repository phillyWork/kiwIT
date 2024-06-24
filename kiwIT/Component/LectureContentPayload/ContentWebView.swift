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

struct ContentWebView: View {
    
    //for notion webview design example
    let url = "https://quartz-concrete-fb2.notion.site/af3f2d0e634d4c649eecca118ae41b93?pvs=4"
    
    var body: some View {
        WebViewSetup(urlString: url)
    }
}

#Preview {
    ContentWebView()
}
