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
  let tracks: Data
}

struct PingRequest: Encodable {
  let type = WebSocketRequest.ping
}

struct StartRoundRequest: Encodable {
  let type = WebSocketRequest.submit_tracks
}

struct GuessMadeRequest: Encodable {
  let type = WebSocketRequest.guess_made
}
