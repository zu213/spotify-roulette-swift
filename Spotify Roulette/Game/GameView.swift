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
      
      HStack {
        Text("Artist\(roundInfo.song.artists.count > 1 ? "s":""): ")
        ForEach(roundInfo.song.artists.enumerated(), id: \.element.name) { i, artist in
          Text("\(artist.name)\(i < roundInfo.song.artists.count - 1 ? ", ": "")")
        }
      }
      Text("Song: \(roundInfo.song.name)")
      
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
  let roundInfo = StartRoundResponse(type: .start_round, song: Song(id: "1", name: "Song 2", artists: [Artist(name: "bob"), Artist(name: "eric")]))
  GameView(
     players: [
       Player(id: "1", playerName: "Zach"),
       Player(id: "2", playerName: "Sam"),
       Player(id: "3", playerName: "Alex")
     ],
     makeGuess: { guess, time in
       print("Guessed \(guess) at \(time)")
     },
     roundInfo: roundInfo,
     roundStartTime: .now,
     isLoading: false
   )
}
