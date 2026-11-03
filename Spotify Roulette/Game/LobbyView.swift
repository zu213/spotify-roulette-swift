//
//  TableView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

import SwiftUI

struct LobbyView: View {
  //let connectViewModel: ConnectViewModel
  @Environment(\.deps) private var deps
  
  let tableId: Int
  let startGame: () async -> Void
      
  var body: some View {
    VStack {
      Text("aaaa")
    }
  }
  
}

#Preview {
  let a = {}
  LobbyView(tableId: 1, startGame: a)
}
