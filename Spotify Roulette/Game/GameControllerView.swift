//
//  GameControllerView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 29/10/2026.
//

import SwiftUI

struct GameControllerView: View {
  @Environment(\.deps) private var deps
  
  @State private var gameViewModel: GameViewModel
  
  init(tokenStore: TokenStore, bridge: Bridge) {
    _gameViewModel = State(initialValue: GameViewModel(tokenStore: tokenStore, bridge: bridge))
  }
    
  var body: some View {
    Group {
      if let hasTokens = gameViewModel.hasTokens {
        if hasTokens {
          Button("Logout") {
            gameViewModel.logout()
          }
          if let tableInfo = gameViewModel.tableInfo {
            Button("Exit Table") {
              gameViewModel.kickPlayerOutOfTable()
            }
            if gameViewModel.gameInPlay ?? false {
              if gameViewModel.roundInPlay ?? false {
                GameView(players: tableInfo.players, makeGuess: gameViewModel.makeGuess, roundInfo: gameViewModel.gameInfo, roundStartTime: gameViewModel.roundStart)
              } else {
                LeaderboardView(scores: tableInfo.scores, startNextRound: gameViewModel.startRound, answer: gameViewModel.roundAnswer?.playerName ?? "UNKNOWN ANSWER")
              }
            } else {
              LobbyView(tableInfo: tableInfo, startGame: gameViewModel.startGame)
            }
          } else {
            JoinView(joinTable: gameViewModel.joinTable, createTable: gameViewModel.createTable)
          }
        } else {
          ConnectView(connectRepo: deps.connectRepo, tokenStore: deps.tokenStore, loadHasTokens: gameViewModel.loadHasTokens)
        }
      }
      else {
        ProgressView()
      }
    }
    .task { await gameViewModel.loadHasTokens() }
  }
}

#Preview {
  let tokenStore = TokenStore()
  let bridge = Bridge(tokenStore: tokenStore)
  GameControllerView(tokenStore: tokenStore, bridge: bridge)
}
