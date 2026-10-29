//
//  ConnectView.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 29/10/2026.
//

import SwiftUI
import AuthenticationServices

struct ConnectView: View {
  @Environment(\.webAuthenticationSession) private var webAuthSession

  @State private var connectViewModel: ConnectViewModel
  @State var isBuildingConnection = false
  
  init(connectRepo: ConnectRepository, tokenStore: TokenStore) {
    _connectViewModel = State(initialValue: ConnectViewModel(connectRepo: connectRepo, tokenStore: tokenStore))
  }
  
  var body: some View {
    // Keeping for now incase i move to tab view
    VStack {
      Text("Connect to Spotify")
      Button("Connect") {
        Task {
          if let url = await connectViewModel.loginToSpotify() {
            do {
              let callbackURL = try await webAuthSession.authenticate(
                  using: url,
                  callbackURLScheme: "com.zachupstone.spotify-roulette"
              )
              await connectViewModel.handleSpotifyLoginCallback(url: callbackURL)
              
            } catch {
              
            }
          }
        }
      }
      .disabled(connectViewModel.isLoading)
    }
    
    if(connectViewModel.isLoading) {
      ProgressView()
    }
    
  }
  
}

#Preview {
  let connectRepo = SpotifyConnectRepository()
  let tokenStore = TokenStore()
  ConnectView(connectRepo: connectRepo, tokenStore: tokenStore)
}
