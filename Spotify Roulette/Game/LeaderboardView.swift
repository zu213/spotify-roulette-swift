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
  let tableCode: Int
  
  @State var isLoading = false
    
  var body: some View {
    VStack {
      VStack {
        Text("Table Code")
          .foregroundStyle(.gray)
        Text(String(tableCode))
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
        Text("Last Round's Answer:")
          .foregroundStyle(.white)
        Text(answer)
          .foregroundStyle(.green)
          .font(.system(.title, design: .rounded))
      }
      
      VStack {
        Text("Leaderboard")
          .foregroundStyle(.white)
          .font(.system(.headline, design: .rounded))
        
        ForEach(Array(scores.enumerated()), id: \.offset) { i, score in
          Divider()
            .overlay(.white)
          Text("\(score.playerName): \(score.score)")
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
      .padding(.all, 4)
      
      Button("Next round") {
        isLoading = true
        defer { isLoading = false }
        Task {
          await startNextRound()
        }
      }
      .foregroundStyle(.black)
      .padding(.all)
      .background(.green.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      .disabled(isLoading)
    }
    .frame(maxWidth: 300, alignment: .leading)
  }
}

#Preview {
  LeaderboardView(
    scores: [
      Score(playerName: "Geraldine", score: 5),
      Score(playerName: "Derek", score: 4)
    ],
    startNextRound: {},
    answer: "Geraldine",
    tableCode: 100
  )
}
