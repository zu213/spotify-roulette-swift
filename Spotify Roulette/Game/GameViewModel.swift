//
//  GameViewModel.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 29/10/2026.
//

import Combine
import Foundation

@Observable
@MainActor
final class GameViewModel {
  private let tokenStore: TokenStore
  var isLoading = false
  var errorMessage: String?
  var hasTokens: Bool?
  
  
  init(tokenStore: TokenStore) {
    self.tokenStore = tokenStore
  }
  
  func loadHasTokens() async {
    print("checking tokens")
    hasTokens = await tokenStore.hasAccessToken()
    print("hasTokens =", hasTokens as Any)  }
}
