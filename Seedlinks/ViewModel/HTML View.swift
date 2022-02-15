//
//  HTML View.swift
//  Seedlinks
//
//  Created by Francesco Puzone on 15/02/22.
//

import SwiftUI
import WebKit

struct HTMLView: UIViewRepresentable {
    let htmlFileName: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
//        uiView.load(htmlFileName)
    }
}
extension WKWebView {
    func load(_ htmlFileName: String) {
        guard !htmlFileName.isEmpty else {
            return print("")
        }
    }
}
