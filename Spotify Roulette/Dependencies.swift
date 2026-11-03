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
  let bridge: Bridge

  init() {
    connectRepo = SpotifyConnectRepository()
    tokenStore = TokenStore()
    bridge = Bridge(tokenStore: tokenStore)
  }
}

extension EnvironmentValues {
  @Entry var deps: AppDependencies = .live
}
