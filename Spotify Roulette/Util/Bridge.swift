//
//  Bridge.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

import Foundation

enum ApiRequestError: Error {
  case non200(String)
  case noData
  case malformedUrl
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
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ApiRequestError.non200("aa") }
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
  
  
  // So as spotify no longer does previews we are using itunes teehee


  func playAudioPreviewFromiTunes(songName: String, artistName: String) async throws -> URL {
    // 1. Format the search query (e.g., "Blinding Lights The Weeknd")
    let searchQuery = "\(songName) \(artistName)"
    guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
          let url = URL(string: "https://itunes.apple.com/search?term=\(encodedQuery)&entity=song&limit=1") else { throw ApiRequestError.malformedUrl }
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let (data, response) = try await URLSession.shared.data(for: request)
    guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ApiRequestError.non200("aa") }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    
    print(String(data: data, encoding: .utf8)!)
    let decodedResponse = try decoder.decode(ItunesResponse.self, from: data)
    guard let result = decodedResponse.results.first else { throw ApiRequestError.noData }
    guard let previewUrl =  URL(string: result.previewUrl) else { throw ApiRequestError.malformedUrl }
    return previewUrl
  }
}


struct ItunesResponse: Decodable {
  let results: [ItunesResult]
}

struct ItunesResult: Decodable {
  let previewUrl: String
}


//print("Found preview URL on iTunes: \(previewUrlString)")
//
//// 4. Play it instantly using native iOS audio
//DispatchQueue.main.async {
//    audioPlayer = AVPlayer(url: previewURL)
//    audioPlayer?.play()
//}
