import Foundation



private class WebSocket: NSObject, URLSessionWebSocketDelegate {
    
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
    print("Web Socket did connect")
  }
  
  func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
    print("Web Socket did disconnect")
  }
}

final class WebSocketConnection {
  private var topTracks: Data?
  private var playerName: String?
  private var url: URL
  private var onMessage: ((WebSocketResponse) -> Void)
  
  private var webSocketDelegate: WebSocket?
  private var session: URLSession?
  private var task: URLSessionWebSocketTask?
  private var heartBeat: String?

    
  init(url: URL, topTracks: Data, playerName: String, onMessage: @escaping ((WebSocketResponse) -> Void)) {
    self.url = url
    self.topTracks = topTracks
    self.playerName = playerName
    self.onMessage = onMessage
  }

  func connect() {
    webSocketDelegate = WebSocket()
    session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
    task = URLSession.shared.webSocketTask(with: url)
    task?.resume()
    task?.resume()
    listen()
    try? sendHeartbeat()
    try? sendTracks()
  }

  func send(_ text: String) async throws {
    try await task?.send(.string(text))
  }

  private func listen() {
    Task {
      do {
        while let task {
          let message = try await task.receive()
          switch message {
          case .string(let text):
            print("websocket got:", text)
            let data = Data(text.utf8)
            try? decodeMessage(data: data)
          case .data(let data):
            print("websocket got data:", data.count, "bytes")
            try? decodeMessage(data: data)
          @unknown default: break
          }
        }
      } catch {
        print("websocket socket closed/error:", error)
      }
    }
  }
  
  func decodeMessage(data: Data) throws {
    let envelope = try JSONDecoder().decode(Envelope.self, from: data)
    if let _ = envelope.type {
      let response = try JSONDecoder().decode(WebSocketResponse.self, from: data)
      onMessage(response)
    } else if let error = envelope.error{
      print(error)
    } else {
      print("Message not decodable")
    }
  }

  func disconnect() {
    task?.cancel(with: .normalClosure, reason: nil)
    task = nil
  }
  
  private func sendHeartbeat() throws {
    guard let task else { return }
    
    let str = PingRequest()
    let data = try JSONEncoder().encode(str)
    let json = String(decoding: data, as: UTF8.self)

    task.send(.string(json)) { error in
      if let error { print("ws send failed:", error) }
    }
    
    DispatchQueue.global().asyncAfter(deadline: .now() + 15) {
      try? self.sendHeartbeat()
    }
  }
  
  private func sendTracks() throws {
    guard let task, let playerName, let topTracks else { return }
    
    let tracks = try JSONDecoder().decode(SpotifyTopTracks.self, from: topTracks)
    let str = SubmitTracksRequest(playerName: playerName, tracks: tracks.items)
    let data = try JSONEncoder().encode(str)
    let json = String(decoding: data, as: UTF8.self)

    task.send(.string(json)) { error in
      if let error { print("ws send failed:", error) }
    }
  }
  
  func startRound() {
    guard let task else { return }
    
    let str = StartRoundRequest()
    if let data = try? JSONEncoder().encode(str) {
      let json = String(decoding: data, as: UTF8.self)
      
      task.send(.string(json)) { error in
        if let error { print("ws send failed:", error) }
      }
    }
  }
  
  func makeGuess(playerId: String?, timeLeft: Int) {
    guard let task else { return }
    
    let str = GuessMadeRequest(playerId: playerId ?? "", timeLeft: timeLeft)
    if let data = try? JSONEncoder().encode(str) {
      let json = String(decoding: data, as: UTF8.self)
      
      task.send(.string(json)) { error in
        if let error { print("ws send failed:", error) }
      }
    }
  }
}
