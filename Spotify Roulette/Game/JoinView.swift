//
//  JoinView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 03/11/2026.
//

import SwiftUI
import Combine

struct JoinView: View {
  //let connectViewModel: ConnectViewModel
  @Environment(\.deps) private var deps
  
  let joinTable: (String, Int) async -> Void
  let createTable: (String) async -> Void
  var isLoadingTable: Bool
  
  @State private var username = ""
  @State private var tableNumber = ""
  @State var isLoading = false
  @State var joinErrorMessage: String? = nil
    
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
            .foregroundStyle(.gray)
        ) {
          Text("Username")
        }
        .foregroundStyle(.white)
        .font(.system(.headline, design: .rounded))
        .padding(.horizontal, 6)
        .padding(.all, 10)
        .overlay {
          RoundedRectangle(cornerRadius: 24)
            .stroke(.green, lineWidth: 2)
        }
        .opacity(isLoading || isLoadingTable ? 0.4 : 1)
        .disabled(isLoading || isLoadingTable)
        TextField(
          text: $tableNumber,
          prompt:
            Text("Table ID")
            .foregroundStyle(.gray)
        ){
          Text("TableId")
        }
        .onReceive(Just(tableNumber)) { _ in limitText(3) }
        .foregroundStyle(.white)
        .font(.system(.headline, design: .rounded))
        .padding(.horizontal, 6)
        .padding(.all, 10)
        .overlay {
          RoundedRectangle(cornerRadius: 24)
            .stroke(.green, lineWidth: 2)
        }
        .opacity(isLoading || isLoadingTable ? 0.4 : 1)
        .disabled(isLoading || isLoadingTable)
      }
      Button("Create Game") {
        if username != "" {
          Task {
            isLoading = true
            defer { isLoading = false }
            await createTable(username)
          }
        } else {
          joinErrorMessage = "No Username Entered"
        }
      }
      .disabled(isLoading || isLoadingTable)
      .foregroundStyle(.black)
      .frame(maxWidth: .infinity, alignment: .center)
      .padding(.all)
      .background(.green.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      .opacity(isLoading || isLoadingTable ? 0.4 : 1)
      Button {
        if username != "" {
          if let tn = Int(tableNumber) {
            Task {
              isLoading = true
              defer { isLoading = false }
              await joinTable(username, tn)
            }
          } else {
            joinErrorMessage = "Invalid Table Code entered"
          }
        } else {
          joinErrorMessage = "No Username Entered"
        }
      } label: {
        Text("Join")
          .frame(maxWidth: .infinity)
          .padding()
      }
      .disabled(isLoading || isLoadingTable)
      .foregroundStyle(.white)
      .frame(maxWidth: .infinity, alignment: .center)
      .background(.black.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      .overlay {
        RoundedRectangle(cornerRadius: 24)
          .stroke(.green, lineWidth: 2)
      }
      .opacity(isLoading || isLoadingTable ? 0.4 : 1)
    }
    .frame(maxWidth: 300, alignment: .leading)
    .padding(.all)
    .background(.black.opacity(1), in: RoundedRectangle(cornerRadius: 16))
    .overlay {
      if(isLoading || isLoadingTable) {
        ProgressView()
          .tint(.white)
          .controlSize(.large)
      }
    }
    .alert(
      joinErrorMessage ?? "NO ERROR FOUND",
      isPresented: Binding(
        get: { joinErrorMessage != nil },
        set: { if !$0 { joinErrorMessage = nil } }
      )
    ) {
      Button("Dismiss") {
        Task {
          joinErrorMessage = nil
        }
      }
    } message: {
      Text(joinErrorMessage ?? "NO ERROR FOUND")
    }
  }
  
  func limitText(_ upper: Int) {
     if tableNumber.count > upper {
       tableNumber = String(tableNumber.prefix(upper))
     }
   }
}

#Preview {
  JoinView(
    joinTable: { a, b in
      print(a)
    }, createTable: { a in
      print(a)
    },
    isLoadingTable: false
  )
}
