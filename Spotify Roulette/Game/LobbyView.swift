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
  
  let tableInfo: TableInfoResponse
  let startGame: () async -> Void
  
  @State var isLoading = false
      
  var body: some View {
    VStack {
      Text("Table code \(tableInfo.tableCode)")
      
      Text("Players")
      ForEach(Array(tableInfo.players.enumerated()), id: \.element.id) { i, player in
        Text("\(i + 1). \(player.playerName)")
      }
      
      Button("Start Game") {
        Task {
          isLoading = true
          defer { isLoading = false }
          await startGame()
        }
      }
      .disabled(isLoading)
    }
  }
  
}

#Preview {
  let a = {}
  let tableInfo = TableInfoResponse(type: .table_info, players: [], scores: [], tableCode: 100)
  LobbyView(tableInfo: tableInfo, startGame: a)
}
