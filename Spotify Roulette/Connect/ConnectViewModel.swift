//
//  ConnectViewModel.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 29/10/2026.
//

import Combine
import Foundation

@Observable
@MainActor
final class ConnectViewModel {
  private let connectRepo: ConnectRepository
  private let tokenStore: TokenStore
  private var verifier: String?
  
  var isLoading = false
  var errorMessage: String?
  
  init(connectRepo: ConnectRepository, tokenStore: TokenStore) {
    self.connectRepo = connectRepo
    self.tokenStore = tokenStore
  }
  
  func loginToSpotify() async -> URL? {
    isLoading = true
    defer { isLoading = false }
    do {
      verifier = connectRepo.generateVerifier(length: 64)
      return try await connectRepo.connectToTarget(verifier: verifier!)
    } catch {
      errorMessage = error.localizedDescription
      return nil
    }
  }
  
  func handleSpotifyLoginCallback(url: URL) async {
    let items = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
    guard items?.first(where: { $0.name == "state" })?.value == "spotify-login",
          let code = items?.first(where: { $0.name == "code" })?.value,
          let verifier = verifier else { return }
    isLoading = true
    defer { isLoading = false }
    try? await tokenStore.exchangeCode(code: code, verifier: verifier)
  }
}
