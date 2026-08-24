//
//  WebViewRepresentable.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 24/08/2026.
//

import WebKit
import SwiftUI

struct WKWebViewRepresentable: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    var url: URL
    var webView: WKWebView
    
    init(url: URL, webView: WKWebView = WKWebView()) {
        self.url = url
        self.webView = webView
    }
    
    /// To let SwiftUI instantiate your views
    func makeUIView(context: Context) -> WKWebView {
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
      webView.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
      //webView.configuration.preferences.jav
      webView.isInspectable = true
    
        
        return webView
    }
    
    /// What to do on redraw
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}

extension WKWebViewRepresentable {
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
    
  final class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
    var parent: WKWebViewRepresentable
    private var webViews: [WKWebView]
        
    init(_ parent: WKWebViewRepresentable) {
        self.parent = parent
        self.webViews = []
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            let popupWebView = WKWebView(frame: .zero, configuration: configuration)
            popupWebView.navigationDelegate = self
            popupWebView.uiDelegate = self
            
            parent.webView.addSubview(popupWebView)
            popupWebView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popupWebView.topAnchor.constraint(equalTo: parent.webView.topAnchor),
                popupWebView.bottomAnchor.constraint(equalTo: parent.webView.bottomAnchor),
                popupWebView.leadingAnchor.constraint(equalTo: parent.webView.leadingAnchor),
                popupWebView.trailingAnchor.constraint(equalTo: parent.webView.trailingAnchor)
            ])
            
            self.webViews.append(popupWebView)
            return popupWebView
        }
        
        return nil
    }
  }
}
