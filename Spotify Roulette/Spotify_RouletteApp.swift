//
//  Spotify_RouletteApp.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 24/08/2026.
//

import SwiftUI
import SwiftData

@main
struct Spotify_RouletteApp: App {
  
  private let deps = AppDependencies()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.deps, deps)
    }
  }
}
