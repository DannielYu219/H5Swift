//
//  ContentView.swift
//  H5Swift
//
//  Created by DannielYu on 6/28/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        EnhancedWebView(
            htmlFileName: "index",  // your main h5 file without ".html"
            contentFolder: ""  //h5 path(none means uder the floder H5Swift)
        )
        .statusBarHidden(true)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
