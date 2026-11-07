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
          Group {
            if let tableInfo = gameViewModel.tableInfo {
              Group {
                if gameViewModel.gameInPlay ?? false {
                  if gameViewModel.roundInPlay ?? false {
                    GameView(players: tableInfo.players, makeGuess: gameViewModel.makeGuess, roundInfo: gameViewModel.gameInfo, roundStartTime: gameViewModel.roundStart)
                  } else {
                    LeaderboardView(scores: tableInfo.scores, startNextRound: gameViewModel.startRound, answer: gameViewModel.roundAnswer?.playerName ?? "UNKNOWN ANSWER")
                  }
                } else {
                  LobbyView(tableInfo: tableInfo, startGame: gameViewModel.startGame)
                }
              }
              .toolbar {
                Button("Exit Table") {
                  gameViewModel.kickPlayerOutOfTable(true)
                }
              }
            } else {
              JoinView(joinTable: gameViewModel.joinTable, createTable: gameViewModel.createTable, isLoadingTable: gameViewModel.isLoading)
            }
          }
          .toolbar {
            Button("Logout") {
              gameViewModel.logout()
            }
          }
          .alert(
            gameViewModel.tableErrorMessage ?? "NO ERROR FOUND",
            isPresented: Binding(
              get: { gameViewModel.tableErrorMessage != nil },
              set: { if !$0 { gameViewModel.tableErrorMessage = nil } }
            )
          ) {
            Button("Exit") {
              gameViewModel.kickPlayerOutOfTable(true)
            }
          } message: {
            Text(gameViewModel.tableErrorMessage ?? "NO ERROR FOUND")
          }
          .alert(
            gameViewModel.gameErrorMessage ?? "NO ERROR FOUND",
            isPresented: Binding(
              get: { gameViewModel.gameErrorMessage != nil },
              set: { if !$0 { gameViewModel.gameErrorMessage = nil } }
            )
          ) {
            Button("Move To Next Round") {
              Task {
                await gameViewModel.makeGuess(playerId: nil, timeGuessed: .now.addingTimeInterval(30))
              }
            }
          } message: {
            Text(gameViewModel.gameErrorMessage ?? "NO ERROR FOUND")
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
