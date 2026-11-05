//
//  IncomingMessages.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

import Foundation


struct Envelope: Decodable {
  let type: WebSocketResponseType?
  let error: String?
}

enum WebSocketResponseType: String, Decodable {
  case start_round
  case table_info
  case pong
  case show_leaderboard
  case no_table
}

enum WebSocketResponse: Decodable {
  case startRound(StartRoundResponse)
  case tableInfo(TableInfoResponse)
  case showLeaderboard(ShowLeaderboardResponse)
  case pong
  case noTable(NoTableResponse)

  private enum CodingKeys: String, CodingKey { case type }

  init(from decoder: Decoder) throws {
    let c = try decoder.container(keyedBy: CodingKeys.self)
    switch try c.decode(WebSocketResponseType.self, forKey: .type) {
    case .start_round:      self = .startRound(try StartRoundResponse(from: decoder))
    case .table_info:       self = .tableInfo(try TableInfoResponse(from: decoder))
    case .show_leaderboard: self = .showLeaderboard(try ShowLeaderboardResponse(from: decoder))
    case .pong:             self = .pong
    case .no_table:         self = .noTable(try NoTableResponse(from: decoder))
    }
  }
}

struct StartRoundResponse: Decodable {
  let type: WebSocketResponseType
  let playerName: String
}

struct PongResponse: Decodable {
  let type: WebSocketResponseType
}

struct TableInfoResponse: Decodable {
  let type: WebSocketResponseType
  let players: [Player]
  let scores: [Score]
  let tableCode: Int

}

struct ShowLeaderboardResponse: Decodable {
  let type: WebSocketResponseType
}

struct NoTableResponse: Decodable {
  let type: WebSocketResponseType
}

struct Player: Decodable {
  let id: String
  let playerName: String
}

struct Score: Decodable {
  let playerName: String
  let score: Int
}
