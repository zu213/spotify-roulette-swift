//
//  Dependencies.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 29/10/2026.
//

import SwiftUI

nonisolated final class AppDependencies: Sendable {
  static let live = AppDependencies()
  
  let connectRepo: SpotifyConnectRepository
  let tokenStore: TokenStore
//    let api: SpotifyAPIRepository

  init() {
    connectRepo = SpotifyConnectRepository()
    tokenStore = TokenStore()
//        api = SpotifyAPIRepository(tokens: tokens)
  }
}

extension EnvironmentValues {
  @Entry var deps: AppDependencies = .live
}
