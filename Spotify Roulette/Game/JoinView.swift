//
//  JoinView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

import SwiftUI

struct JoinView: View {
  //let connectViewModel: ConnectViewModel
  @Environment(\.deps) private var deps
  
  let joinTable: (String, Int) async -> Void
  let createTable: (String) async -> Void
  
  @State private var username = ""
  @State private var tableNumber = ""
    
  var body: some View {
    VStack {
      Text("Create or Join a Table")
        .font(.system(.title, design: .rounded))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .foregroundStyle(.white)
      Text("In each round, a random song that someone likes is played. Everyone guesses who likes the song the most, based on their Spotify listening history.")
        .foregroundStyle(.white)
        .font(.system(.subheadline, design: .rounded))
      VStack {
        TextField(
          text: $username,
          prompt: Text("Username")
            .foregroundStyle(.white)
        ) {
          Text("Username")
        }
        .foregroundStyle(.white)
        .font(.system(.headline, design: .rounded))
        .padding(.all, 10)
        .overlay {
          RoundedRectangle(cornerRadius: 24)
            .stroke(.green, lineWidth: 2)
        }
        TextField(
          text: $tableNumber,
          prompt: Text("Table ID")
            .foregroundStyle(.white)
        ){
          Text("TableId")
        }
        .font(.system(.headline, design: .rounded))
        .padding(.all, 10)
        .overlay {
          RoundedRectangle(cornerRadius: 24)
            .stroke(.green, lineWidth: 2)
        }
      }
      Button("Create Game") {
        guard username != "" else { return }
        Task { await createTable(username) }
      }
      .foregroundStyle(.black)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.all)
      .background(.green.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      Button("Join") {
        if let tn = Int(tableNumber) {
          Task { await joinTable(username, tn) }
        }
      }
      .foregroundStyle(.gray)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.all)
      .background(.black.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      .overlay {
        RoundedRectangle(cornerRadius: 24)
          .stroke(.green, lineWidth: 2)
      }
    }
    .frame(maxWidth: 300, alignment: .leading)
    .padding(.all)
    .background(.black.opacity(1), in: RoundedRectangle(cornerRadius: 16))
  }

}

#Preview {
  JoinView()
    { a, b in
      print(a)
    } createTable: { a in
      print(a)
    }
}
