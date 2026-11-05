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
  var answer: Player?
  
  // Game related
  var gameInPlay: Bool?
  var gameInfo: StartRoundResponse?
  var roundInPlay: Bool?
  var roundStart: Date?
  
  // Websocket
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
    gameInPlay = true
    await startRound()
  }
  
  func startRound() async {
    roundInPlay = true
    webSocketConnection?.startRound()
  }
  
  func makeGuess(playerId: String?, timeGuessed: Date) async {
    guard let roundStart else { return }
    let timeLeft = max(30 - Int(timeGuessed.timeIntervalSince(roundStart).rounded()), 0)
    webSocketConnection?.makeGuess(playerId: playerId, timeLeft: timeLeft)
  }
  
  func kickPlayerOutOfTable() {
    gameInPlay = nil
    roundInPlay = nil
    tableInfo = nil
    answer = nil
    roundStart = nil
    gameInfo = nil
    webSocketConnection?.disconnect()
    webSocketConnection = nil
  }
  
  func logout() {
    kickPlayerOutOfTable()
    hasTokens = nil
    Task {
      await tokenStore.clear()
    }
  }

  func decodeMessage(wsr: WebSocketResponse) {
    switch wsr {
    case .startRound(let roundMessage):
      gameInfo = roundMessage
      roundInPlay = true
      roundStart = .now
      Task {
         do {
           try await Task.sleep(for: .seconds(30))
           await makeGuess(playerId: nil, timeGuessed: .now)
         } catch {
         }
       }
      break
      // handle
    case .tableInfo(let tableInfo):
      print(tableInfo)
      self.tableInfo = tableInfo
      
      break
    case .showLeaderboard(let leaderboardInfo):
      roundInPlay = false
      tableInfo?.scores = leaderboardInfo.scores
      answer = leaderboardInfo.answer
      break
    case .noTable(let noTable):
      kickPlayerOutOfTable()
      break
    case .pong:
      break
    }
  }
}
