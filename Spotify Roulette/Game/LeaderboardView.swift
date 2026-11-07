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
    VStack(spacing: 16) {
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
          HStack {
            Text(score.playerName)
            Spacer()
            Text(String(score.score))
              .monospacedDigit()
              .foregroundStyle(.green)
          }
          .foregroundStyle(.white)
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
          await startNextRound()
        }
      } label: {
        Text("Next Round")
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
