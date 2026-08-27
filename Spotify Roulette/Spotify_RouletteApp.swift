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

  
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
          ZStack {
            Color.black.ignoresSafeArea()
            ContentView()
          }
        }
        .modelContainer(sharedModelContainer)
    }
}
