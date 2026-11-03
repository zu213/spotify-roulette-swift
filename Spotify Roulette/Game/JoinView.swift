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
    Text("cREAT OR JOIN A TABLE")
    TextField(text: $username, prompt: Text("Required")) {
        Text("Username")
    }
    TextField(text: $tableNumber, prompt: Text("Required")){
        Text("TableId")
    }
    Button("Create") {
      guard username != "" else { return }
      Task { await createTable(username) }
    }
    Button("Join") {
      if let tn = Int(tableNumber) {
        Task { await joinTable(username, tn) }
      }
    }
  }
  
}

#Preview {
  //JoinView()
}
