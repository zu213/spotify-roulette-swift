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

struct ConnectView: View {
  
  func connectToSpotify() async throws {
    let url = URL(string: "")
    let response = try await URLSession.shared.data(from: url!)
  }
  
  func getSpotifyAuthUrl(clientId: String, redirectUri: String) async -> String {
    var verifier = generateRandomString(length: 64)
    //window.localStorage.setItem('code_verifier', verifier)
    const challenge = await generateCodeChallenge(verifier)
    
    var params = "client_id=\(clientId)&response_type=code&redirect_uri=\(redirectUri)&scope=user-top-read&state=spotify-login&code_challenge_method=S256&code_challenge=\(challenge)"

    return "https://accounts.spotify.com/authorize?\(params)"
  }
  
  func generateRandomString(length: Int) -> String {
    let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    var output = ""
    for _ in 1...length {
      output += String(possible.randomElement()!)
    }
    return output
  }
  
  func generateCodeChallenge(verifier: String) async {
    let digest = sha256(string: verifier)
    
    return btoa(String.fromCharCode(...new Uint8Array(digest)))
      .replace(/\+/g, '-')
      .replace(/\//g, '_')
      .replace(/=+$/, '')
  }
  
  func sha256(string: String) -> String? {
      guard let data = string.data(using: .utf8) else { return nil }
      let hashed = SHA256.hash(data: data)
      return hashed.compactMap { String(format: "%02x", $0) }.joined()
  }

  var body: some View {
    ZStack {
      Color.black.ignoresSafeArea()

      Button("Connect") {
        Task {
          do {
            try await connectToSpotify()
          } catch {
            print(error)
          }
        }
      }
      .padding(.all, 20)
      .background(Color.green)
      .clipShape(Capsule())
      .foregroundStyle(.black)
    }
  }
}

#Preview {
    ConnectView()
}
