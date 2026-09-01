//
//  ContentView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 24/08/2026.
//

import SwiftUI
import SwiftData
import WebKit

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
      WKWebViewRepresentable(url: URL(string: "https://zupstn.com/#/spotify-roulette-demo")!)
    }
}

#Preview {
    ContentView()
}
