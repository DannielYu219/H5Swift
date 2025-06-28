//
//  Core.swift
//  H5Swift
//
//  Created by DannielYu on 6/28/25.
//

import Foundation
import UIKit
import WebKit
import SwiftUI

struct WebView: UIViewRepresentable {
    let htmlFileName: String
    let contentFolder: String
    var onLoadStateChange: ((LoadState) -> Void)?
    
    enum LoadState {
        case idle
        case loading
        case success
        case failure(Error)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        
        if #available(iOS 14.0, *) {
            config.defaultWebpagePreferences.allowsContentJavaScript = true
            config.limitsNavigationsToAppBoundDomains = false
        } else {
            config.preferences.javaScriptEnabled = true
        }
        
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        loadContent(in: uiView)
    }
    
    private func loadContent(in webView: WKWebView) {
        onLoadStateChange?(.loading)
        
        guard let baseURL = Bundle.main.resourceURL?.appendingPathComponent(contentFolder) else {
            let error = NSError(domain: "WebViewError", code: 0,
                               userInfo: [NSLocalizedDescriptionKey: "file path is disappear"])
            onLoadStateChange?(.failure(error))
            return
        }
        
        let fileURL = baseURL.appendingPathComponent("\(htmlFileName).html")
        
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            let error = NSError(domain: "WebViewError", code: 404,
                               userInfo: [NSLocalizedDescriptionKey: "cannot find the file: \(fileURL.lastPathComponent)"])
            onLoadStateChange?(.failure(error))
            return
        }
        
        webView.loadFileURL(fileURL, allowingReadAccessTo: baseURL)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.onLoadStateChange?(.success)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.onLoadStateChange?(.failure(error))
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            parent.onLoadStateChange?(.failure(error))
        }
    }
}

struct EnhancedWebView: View {
    let htmlFileName: String
    let contentFolder: String
    
    @State private var loadState: WebView.LoadState = .idle
    
    var body: some View {
        ZStack {
            // 主 WebView
            WebView(
                htmlFileName: htmlFileName,
                contentFolder: contentFolder,
                onLoadStateChange: { state in
                    loadState = state
                }
            )
            .edgesIgnoringSafeArea(.all)
            
            // load cover
            overlayView
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch loadState {
        case .idle, .success:
            EmptyView()
        case .loading:
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
        case .failure(let error):
            VStack {
                Spacer()
                errorView(error: error)
                Spacer()
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemBackground))
        }
    }
    
    private func errorView(error: Error) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 40))
                .foregroundColor(.yellow)
            
            Text("load error")
                .font(.title2.bold())
            
            Text(error.localizedDescription)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            Button(action: reload) {
                Label("reload", systemImage: "arrow.clockwise")
                    .font(.headline)
                    .padding(8)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(12)
    }
    
    private func reload() {
        loadState = .loading
        // reload WebView's updateUIView
    }
}
