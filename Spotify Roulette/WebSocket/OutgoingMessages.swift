//
//  OutgoingMessages.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

import Foundation

enum OutgoingMessage: Decodable {
  case items(items: [String])
  case update(item: String)
  case add(item: String)
  case delete(item: String)
}
