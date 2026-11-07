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
    VStack(spacing: 16) {
      VStack {
        Text("Table Code")
          .foregroundStyle(.gray)
        Text(String(tableInfo.tableCode))
          .font(.system(.largeTitle, design: .rounded))
          .foregroundStyle(.green)
      }
      .padding(.all)
      .overlay {
        RoundedRectangle(cornerRadius: 24)
          .stroke(.green, lineWidth: 2)
      }
      .background(.black.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      
      VStack {
        Text("Players:")
          .foregroundStyle(.white)
          .frame(maxWidth: .infinity, alignment: .leading)
        ForEach(Array(tableInfo.players.enumerated()), id: \.element.id) { i, player in
          Divider()
            .overlay(.white)
          Text("\(i + 1). \(player.playerName)")
            .foregroundStyle(.white)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
      }
      .padding(.all)
      .background(.black.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      .frame(maxWidth: .infinity, alignment: .leading)
      .overlay {
        RoundedRectangle(cornerRadius: 24)
          .stroke(.white, lineWidth: 0.5)
      }
      
      Button {
        Task {
          isLoading = true
          defer { isLoading = false }
          await startGame()
        }
      } label: {
        Text("Start Game")
          .frame(maxWidth: .infinity)
          .padding()
      }
      .foregroundStyle(.black)
      .background(.green.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      .disabled(isLoading)
      .opacity(isLoading ? 0.4 : 1)
    }
    .frame(maxWidth: 300, alignment: .leading)
  }
  
}

#Preview {
  let tableInfo = TableInfoResponse(
    type: .table_info,
    players: [
      Player(id: "1", playerName: "Derek"),
      Player(id: "2", playerName: "Geraldine")
    ],
    scores: [
      Score(playerName: "Geraldine", score: 5),
      Score(playerName: "Derek", score: 4)
    ],
    tableCode: 100
  )
  LobbyView(tableInfo: tableInfo, startGame: {})
}
