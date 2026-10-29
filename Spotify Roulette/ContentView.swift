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
  @Environment(\.deps) private var deps

  var body: some View {
    // Keeping for now incase i move to tab view
    GameView(tokenStore: deps.tokenStore)
  }
}

#Preview {
    ContentView()
}
