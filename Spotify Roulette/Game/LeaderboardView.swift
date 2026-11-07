//
//  LeaderboardView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 05/11/2026.
//

import SwiftUI

struct LeaderboardView: View {
  //let connectViewModel: ConnectViewModel
  let scores: [Score]
  let startNextRound: () async -> Void
  let answer: String
  
  @State var isLoading = false
    
  var body: some View {
    Text("Scores on the doors")

    ForEach(Array(scores.enumerated()), id: \.offset) { i, score in
      Text("\(score.playerName): \(score.score)")
    }

    Button("Next round") {
      isLoading = true
      defer { isLoading = false }
        Task {
          await startNextRound()
        }
      }
    .disabled(isLoading)
  }
  
}

#Preview {
  LeaderboardView(
    scores: [
      Score(playerName: "Geraldine", score: 5),
      Score(playerName: "Derek", score: 4)
    ],
    startNextRound: {},
    answer: "Geraldine"
  )
}
