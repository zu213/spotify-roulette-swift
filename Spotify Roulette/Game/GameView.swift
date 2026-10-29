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
    
  var body: some View {
    // Keeping for now incase i move to tab view
    
    ConnectView(connectRepo: deps.connectRepo, tokenStore: deps.tokenStore)
  }
  
}

#Preview {
  //let viewModel = ConnectViewModel(repo: repo)
  GameView()
}
