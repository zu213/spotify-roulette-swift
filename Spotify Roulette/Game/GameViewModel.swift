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
  
  // user related
  var hasTokens: Bool?
  var topTracks: Data?
  
  // Table related
  var tableInfo: TableInfoResponse?
  
  var webSocketConnection: WebSocketConnection?
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
    guard let _ =  hasTokens, topTracks == nil else { return }
    topTracks = await bridge.requestTopTracks()
  }
  
  func createTable(name: String) async {
    await requestTopTracks()
    guard let topTracks else { return }
    
    let url = WEBSOCKET_BASE_URL.appending(queryItems: [
      URLQueryItem(name: "playername", value: name)
    ])
    webSocketConnection = WebSocketConnection(url: url, topTracks: topTracks, playerName: name, onMessage: decodeMessage)
    webSocketConnection?.connect()
  }
  
  func joinTable(name: String, code: Int) async {
    await requestTopTracks()
    guard let topTracks else { return }
    
    let url = WEBSOCKET_BASE_URL.appending(queryItems: [
      URLQueryItem(name: "playername", value: name),
      URLQueryItem(name: "tableid", value: String(code))
    ])
    webSocketConnection = WebSocketConnection(url: url, topTracks: topTracks, playerName: name, onMessage: decodeMessage)
    webSocketConnection?.connect()
  }
  
  func startGame() async {
    webSocketConnection
  }
  
  func decodeMessage(wsr: WebSocketResponse) {
    switch wsr {
    case .startRound(let r):
      break
      // handle
    case .tableInfo(let tableInfo):
      print(tableInfo)
      self.tableInfo = tableInfo
      break
    case .showLeaderboard(let s):
      break
    case .noTable(let n):
      break
    case .pong:
      break
    }
  }
}
