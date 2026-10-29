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
  
  init(tokenStore: TokenStore) {
    _gameViewModel = State(initialValue: GameViewModel(tokenStore: tokenStore))
  }
    
  var body: some View {
    Group {
      if let hasTokens = gameViewModel.hasTokens {
        if hasTokens {
          Text("has tokens")
        } else {
          ConnectView(connectRepo: deps.connectRepo, tokenStore: deps.tokenStore)
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
  GameView(tokenStore: tokenStore)
}
