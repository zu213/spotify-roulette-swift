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
    VStack {
      Text("Time Remaining")
        .foregroundStyle(.white)
      
      if let roundInfo, let roundStartTime {
        TimelineView(.periodic(from: roundStartTime, by: 1)) { context in
          let remaining = max(0, gameDuration - Int(context.date.timeIntervalSince(roundStartTime)))
          Text("\(remaining)")
            .font(.largeTitle.monospacedDigit())
            .foregroundStyle(.white)
          
          if let albumCover = roundInfo.song.album.images.first {
            AsyncImage(url: albumCover.url) { image in
              image
                .resizable()
                .scaledToFill()
            } placeholder: {
              ProgressView().tint(.white)
            }
            .frame(width: 200, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .opacity(remaining < 20 ? 1 : 0)
            .overlay {
              RoundedRectangle(cornerRadius: 12)
                .stroke(.green, style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
                .opacity(remaining >= 20 ? 1 : 0)
            }
            .padding(.bottom, 5)
          }
          
          HStack {
            Text("Artist\(roundInfo.song.artists.count > 1 ? "s":""):")
              .foregroundStyle(.white)
            ForEach(roundInfo.song.artists.enumerated(), id: \.element.name) { i, artist in
              Text("\(artist.name)\(i < roundInfo.song.artists.count - 1 ? ",": "")")
                .foregroundStyle(remaining < 15 ? .white : .clear)
            }
          }
          .padding(.all, 7)
          
          HStack {
            Text("Song:")
              .foregroundStyle(.white)
            Text("\(roundInfo.song.name)")
              .foregroundStyle(remaining < 5 ? .white : .clear)
          }
          .padding(.all, 7)
        }
        
        //roundInfo.song.
        HStack {
          ForEach(players, id: \.id) { player in
            Button(player.playerName) {
              Task { await makeGuess(player.id, .now) }
            }
            .foregroundStyle(.white)
            .padding(.all)
            .background(.green.opacity(1), in: RoundedRectangle(cornerRadius: 24))
          }
        }
        .padding(.top, 5)

      } else {
        ProgressView()
      }
    }
    .padding(.all)
    .frame(maxWidth: 300, alignment: .center)
    .background(.black.opacity(1), in: RoundedRectangle(cornerRadius: 24))
  }
}

#Preview {
  let roundInfo = StartRoundResponse(
    type: .start_round,
    song: Song(
      id: "1",
      name: "Song 2",
      artists: [Artist(name: "bob"), Artist(name: "eric")],
      album: Album(
        images: [
          SpotifyImages(url: URL(string: "https://i.scdn.co/image/ab67616d0000b2734b1cfe102ed2d9627c6c6802")!)
        ]
      )
    )
  )
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
