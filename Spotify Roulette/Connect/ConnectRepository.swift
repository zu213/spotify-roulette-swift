//
//  Connect.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 31/08/2026.
//


import SwiftUI
import SwiftData
import WebKit
import CryptoKit
import Foundation

protocol ConnectRepository {
  func connectToTarget(verifier: String) async throws -> URL
  func generateVerifier(length: Int) -> String
}

enum SpotifyConnectError: Error {
    case runtimeError(String)
}

struct SpotifyConnectRepository: ConnectRepository {
  let REDIRECT_URI = AppConfig.redirectUrl
  let CLIENT_ID = AppConfig.spotifyClientId
  
  func connectToTarget(verifier: String) async throws -> URL {
    guard let rawUrl = await getSpotifyAuthUrl(clientId: CLIENT_ID, redirectUri: REDIRECT_URI, verifier: verifier) else { throw SpotifyConnectError.runtimeError("succ mas") }
    guard let url = URL(string: rawUrl) else { throw SpotifyConnectError.runtimeError("succ") }
    return url
  }
  
  private func getSpotifyAuthUrl(clientId: String, redirectUri: URL, verifier: String) async -> String? {
    do {
      if let challenge = await generateCodeChallenge(verifier: verifier) {
        let params = "client_id=\(clientId)&response_type=code&redirect_uri=\(redirectUri.absoluteString)&scope=user-top-read&state=spotify-login&code_challenge_method=S256&code_challenge=\(challenge)"
        return "https://accounts.spotify.com/authorize?\(params)"
      }
    }
    return nil
  }
  
  func generateVerifier(length: Int) -> String {
    let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    var output = ""
    for _ in 1...length {
      output += String(possible.randomElement()!)
    }
    return output
  }
  
  private func generateCodeChallenge(verifier: String) async -> String? {
    guard let data = verifier.data(using: .utf8) else { return nil }
    let hashed = SHA256.hash(data: data)
    let base64String = Data(hashed).base64EncodedString()
    
    return base64String
      .replacing("+", with: "-")
      .replacing("/", with: "_")
      .replacing(/=+$/, with: "")
  }
}
