//
//  GameView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 29/10/2026.
//

import SwiftUI

struct GameView: View {
  //let connectViewModel: ConnectViewModel
  @Environment(\.deps) private var deps
  
  @State private var gameViewModel: GameViewModel
  
  init(tokenStore: TokenStore, bridge: Bridge) {
    _gameViewModel = State(initialValue: GameViewModel(tokenStore: tokenStore, bridge: bridge))
  }
    
  var body: some View {
    Group {
      if let hasTokens = gameViewModel.hasTokens {
        if hasTokens {
          if let tableId = gameViewModel.tableId {
            LobbyView(tableId: tableId, startGame: gameViewModel.startGame)
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
  //let viewModel = ConnectViewModel(repo: repo)
  let tokenStore = TokenStore()
  let bridge = Bridge(tokenStore: tokenStore)
  GameView(tokenStore: tokenStore, bridge: bridge)
}
