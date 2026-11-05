//
//  GameView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 05/11/2026.
//

import SwiftUI

struct GameView: View {
  //let connectViewModel: ConnectViewModel
  let players: [Player]
  let makeGuess: (String, Date) async -> Void
  let roundInfo: StartRoundResponse?
  let roundStartTime: Date?
  let gameDuration = 30
  
  @State var isLoading = false
    
  var body: some View {
    Text("Game")
    
    if let roundInfo, let roundStartTime {
      TimelineView(.periodic(from: roundStartTime, by: 1)) { context in
        let remaining = max(0, gameDuration - Int(context.date.timeIntervalSince(roundStartTime)))
        Text("\(remaining)")
          .font(.largeTitle.monospacedDigit())
      }
      Text("song: \(roundInfo.song)")
      
      ForEach(players, id: \.id) { player in
        Button(player.playerName) {
          Task { await makeGuess(player.id, .now) }
        }
      }
      
    } else {
      Text("loading")
    }
  }
  
}

#Preview {
  //JoinView()
}
