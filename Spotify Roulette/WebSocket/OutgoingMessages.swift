//
//  OutgoingMessages.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

import Foundation

enum WebSocketRequest: String, Encodable {
  case submit_tracks
  case start_round
  case ping
  case guess_made
}

struct SubmitTracksRequest: Encodable {
  let type = WebSocketRequest.submit_tracks
  let playerName: String
  let tracks: [SpotifyTrack]
}

struct PingRequest: Encodable {
  let type = WebSocketRequest.ping
}

struct StartRoundRequest: Encodable {
  let type = WebSocketRequest.start_round
}

struct GuessMadeRequest: Encodable {
  let type = WebSocketRequest.guess_made
  let playerId: String
  let timeLeft: Int
}

struct SpotifyTrack: Codable {
  let id: String
  let name: String
  let album: Album
  let artists: [Artist]
  struct Album: Codable { let name: String; let images: [Image] }
  struct Image: Codable { let url: String }
  struct Artist: Codable { let name: String }
}

struct SpotifyTopTracks: Codable {
  let items: [SpotifyTrack]
}
