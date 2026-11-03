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
  private let bridge: Bridge
  
  var isLoading = false
  var errorMessage: String?
  var hasTokens: Bool?
  var tableId: Int?
  var topTracks: Data?
  
  var webSocketConnection = WebSocket()
  let WEBSOCKET_BASE_URL = AppConfig.serverUrl
  
  init(tokenStore: TokenStore, bridge: Bridge) {
    self.tokenStore = tokenStore
    self.bridge = bridge
  }
  
  func loadHasTokens() async {
    isLoading = true
    defer { isLoading = false }

    hasTokens = await tokenStore.hasAccessToken()
    await requestTopTracks()
  }
  
  func requestTopTracks() async {
    guard let hasTokens, topTracks == nil else { return }
    topTracks = await bridge.requestTopTracks()
  }
  
  func createTable(name: String) async {
    await requestTopTracks()
    guard let topTracks else { return }
    
    let url = WEBSOCKET_BASE_URL.appending(queryItems: [
      URLQueryItem(name: "playername", value: name)
    ])
    webSocketConnection.connect(to: url)
  }
  
  func joinTable(name: String, code: Int) async {
    await requestTopTracks()
    guard let topTracks else { return }
    
    let url = WEBSOCKET_BASE_URL.appending(queryItems: [
      URLQueryItem(name: "playername", value: name),
      URLQueryItem(name: "tableid", value: String(code))
    ])
    webSocketConnection.connect(to: url)
  }
  
  func startGame() async {
    
  }
}
