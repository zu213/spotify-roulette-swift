//
//  AppConfig.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 29/10/2026.
//

import Foundation

nonisolated enum AppConfig {
    static let redirectUrl: URL = {
    guard let s = Bundle.main.object(forInfoDictionaryKey: "REDIRECT_URI") as? String,
      let url = URL(string: s) else { fatalError("API_BASE_URL missing") }
    return url
  }()

  static let spotifyClientId: String = {
      guard let s = Bundle.main.object(forInfoDictionaryKey: "SPOTIFY_CLIENT_ID") as? String else {
        fatalError("API_KEY missing")
      }
      return s
  }()
  
  static let serverUrl: URL = {
    guard let string = Bundle.main.object(forInfoDictionaryKey: "REACT_APP_SERVER_URL") as? String,
      let url = URL(string: string) else { fatalError("REACT_APP_SERVER_URL missing") }
    return url
  }()
}
