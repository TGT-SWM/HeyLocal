//
//  WebView.swift
//  HeyLocal
//
//  Copyright (c) 2022 TGT All rights reserved.
//

import SwiftUI
import UIKit
import Combine
import WebKit

struct WebView: UIViewRepresentable {
    var url: String
    @ObservedObject var viewModel: WebViewModel
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let preferences = WKPreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = false
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(frame: CGRect.zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.isScrollEnabled = true
        
        if let url = URL(string: url) {
            webView.load(URLRequest(url: url))
        }
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var foo: AnyCancellable? = nil
        
        // 생성자
        init(_ uiWebView: WebView) {
            self.parent = uiWebView
        }
        
        // 소멸자
        deinit {
            foo?.cancel()
        }
        
        func webView(_ webView: WKWebView,
                     decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            
//            if let host = navigationAction.request.url?.host {
//                if host != "velog.io" {
//                    return decisionHandler(.cancel)
//                }
//            }
            
            parent.viewModel.bar.send(false)
            self.foo = self.parent.viewModel.foo.receive(on: RunLoop.main)
                .sink(receiveValue: { value in
                    print(value)
                })
            
            return decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            print("기본 프레임에서 탐색이 시작되었음")
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            print("내용을 수신하기 시작")
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("탐색이 완료")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            print("초기 탐색 프로세스 중 오류 발생")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError: Error) {
            print("탐색 중 오류 발생")
        }
    }
}
