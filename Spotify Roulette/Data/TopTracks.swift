//
//  TopTracks.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

nonisolated struct TopTracks: Decodable {
  let items: [Track]
}

struct Track: Decodable {
  let artists: Artists
}

struct Artists: Decodable {
  let name: String
}
