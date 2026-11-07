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
  @State private var errorMessage: String? = nil
  
  private var loadHasTokens: () async -> Void
  
  init(connectRepo: ConnectRepository, tokenStore: TokenStore, loadHasTokens: @escaping () async -> Void) {
    _connectViewModel = State(initialValue: ConnectViewModel(connectRepo: connectRepo, tokenStore: tokenStore))
    self.loadHasTokens = loadHasTokens
  }
  
  var body: some View {
    // Keeping for now incase i move to tab view
    VStack {
      Text("You need to connect the app to spotify to access your top tracks.")
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .padding(.all)
      Button {
        Task {
          await connectToSpotify()
        }
      } label: {
        Text("Connect To Spotify")
          .padding()
      }
      .foregroundStyle(.black)
      .background(.green.opacity(1), in: RoundedRectangle(cornerRadius: 24))
      .disabled(isBuildingConnection)
      .opacity(isBuildingConnection ? 0.4 : 1)
    }
    .padding(.all)
    .background(.black.opacity(1), in: RoundedRectangle(cornerRadius: 24))
    .overlay {
      if(isBuildingConnection) {
        ProgressView()
          .tint(.white)
      }
    }
    .alert(
      errorMessage ?? "NO ERROR FOUND",
      isPresented: Binding(
        get: { errorMessage != nil },
        set: { if !$0 { errorMessage = nil } }
      )
    ) {
      Button("Retry") {
        Task {
          await connectToSpotify()
          errorMessage = nil
        }
      }
    } message: {
      Text(errorMessage ?? "NO ERROR FOUND")
    }
  }
  
  private func connectToSpotify() async {
    isBuildingConnection = true
    if let url = await connectViewModel.loginToSpotify() {
      do {
        defer { isBuildingConnection = false }
        let callbackURL = try await webAuthSession.authenticate(
            using: url,
            callbackURLScheme: "com.zachupstone.spotify-roulette"
        )
        await connectViewModel.handleSpotifyLoginCallback(url: callbackURL)
        await loadHasTokens()
      } catch let error {
        errorMessage = error.localizedDescription
      }
    }
  }
}

#Preview {
  let connectRepo = SpotifyConnectRepository()
  let tokenStore = TokenStore()
  ConnectView(connectRepo: connectRepo, tokenStore: tokenStore, loadHasTokens: {})
}
