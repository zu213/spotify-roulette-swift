//
//  Token.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//


nonisolated struct Token: Decodable {
  let accessToken: String
  let tokenType: String
  let expiresIn: Int
  let refreshToken: String?
  let scope: String
}
