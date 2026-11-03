//
//  Bridge.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

import Foundation

enum apiRequestError: Error {
  case non200(String)
}

nonisolated struct Bridge {
  private var tokenStore: TokenStore
  
  init(tokenStore: TokenStore) {
    self.tokenStore = tokenStore
  }
  
  func requestTopTracks() async -> Data? {
    do {
      let token = try await tokenStore.validAccessToken()
      if let url =  URL(string: "https://api.spotify.com/v1/me/top/tracks") {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw apiRequestError.non200("aa") }
        print(response)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        print(String(data: data, encoding: .utf8)!)
        
        //let decodedResponse = try decoder.decode(TopTracks.self, from: data)

        return data
      }
    } catch let error {
      print(error.localizedDescription)
    }
    return nil
  }
}
