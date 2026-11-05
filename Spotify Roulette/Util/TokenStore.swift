//
//  TokenStore.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 29/10/2026.
//

import Foundation

enum AuthError: Error {
  case notLoggedIn
  case noRefreshToken
}


actor TokenStore {
  private let key = "spotify.tokens"
  private var cached: StoredTokens?
  
  let REDIRECT_URI = AppConfig.redirectUrl
  let CLIENT_ID = AppConfig.spotifyClientId

  func save(_ tokens: StoredTokens) {
    cached = tokens
    Keychain.save(try! JSONEncoder().encode(tokens), key: key)
  }

  func validAccessToken() async throws -> String {
    if cached == nil, let data = Keychain.load(key: key) {
      cached = try? JSONDecoder().decode(StoredTokens.self, from: data)
    }
    guard let tokens = cached else { throw AuthError.notLoggedIn }

    if tokens.isExpired {
      let refreshed = try await refresh(refreshToken: tokens.refreshToken)
      save(refreshed)
      return refreshed.accessToken
    }
    return tokens.accessToken
  }
  
  func hasAccessToken() -> Bool {
    if cached == nil, let data = Keychain.load(key: key) {
        cached = try? JSONDecoder().decode(StoredTokens.self, from: data)
    }
    return cached != nil
  }

  func clear() {
    cached = nil
    Keychain.delete(key: key)
  }
  
  func exchangeCode(code: String, verifier: String) async throws {
    var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    var body = URLComponents()
    body.queryItems = [
      URLQueryItem(name: "grant_type", value: "authorization_code"),
      URLQueryItem(name: "code", value: code),
      URLQueryItem(name: "redirect_uri", value: REDIRECT_URI.absoluteString),
      URLQueryItem(name: "client_id", value: CLIENT_ID),
      URLQueryItem(name: "code_verifier", value: verifier),
    ]
    request.httpBody = body.percentEncodedQuery?.data(using: .utf8)

    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
        
    let decodedResponse = try decoder.decode(Token.self, from: data)
    guard let refresh = decodedResponse.refreshToken else { throw AuthError.noRefreshToken }
    
    let storableTokens = StoredTokens(accessToken: decodedResponse.accessToken, refreshToken: refresh, expiresAt: Date.now + TimeInterval(decodedResponse.expiresIn))
    save(storableTokens)
  }
  
  func refresh(refreshToken: String) async throws -> StoredTokens {
    var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
    request.httpMethod = "POST"
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

    var body = URLComponents()
    body.queryItems = [
      URLQueryItem(name: "grant_type", value: "refresh_token"),
      URLQueryItem(name: "refresh_token", value: refreshToken),
      URLQueryItem(name: "client_id", value: CLIENT_ID),
    ]
    request.httpBody = body.percentEncodedQuery?.data(using: .utf8)

    let (data, _) = try await URLSession.shared.data(for: request)
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    print(String(data: data, encoding: .utf8)!)
    
    let decodedResponse = try decoder.decode(Token.self, from: data)
    print(decodedResponse)
    
    let storableTokens = StoredTokens(accessToken: decodedResponse.accessToken, refreshToken: refreshToken, expiresAt: Date.now + TimeInterval(decodedResponse.expiresIn))
    return storableTokens
  }
}
