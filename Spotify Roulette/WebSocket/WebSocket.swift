import Foundation

final class WebSocket {
  private var task: URLSessionWebSocketTask?
  private var heartBeat: String?

  func connect(to url: URL) {
    task = URLSession.shared.webSocketTask(with: url)
    task?.resume()
    listen()
    startHeartbeat()
    sendTracks()
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
          case .string(let text): print("websocket got:", text)
          case .data(let data):   print("websocket got data:", data.count, "bytes")
          @unknown default: break
          }
        }
      } catch {
        print("websocket socket closed/error:", error)
      }
    }
  }

  func disconnect() {
    task?.cancel(with: .normalClosure, reason: nil)
    task = nil
  }
  
  private func sendTracks() {
    
  }
  
  private func startHeartbeat() {
    
  }
  
}
