import ComposableArchitecture
import Match
import SwiftUI

@main
struct DFPadelApp: App {
  let store = Store(initialState: .init(matches: []), reducer: DFPadel())

  public var body: some Scene {
    WindowGroup {
      WithViewStore(self.store) { viewStore in
        Group {
          if viewStore.shouldShowMatch {
            MatchView(
              store: .init(
                initialState: .init(match: .init(
                  teamA: .init(playerA: .init(name: "GIF"), playerB: .init(name: "MC")),
                  teamB: .init(playerA: .init(name: "DF"), playerB: .init(name: "DF")),
                  deuce: .golden
                )),
                reducer: MatchFeature()
              )
            )
          } else {
            Button("New match", action: { viewStore.send(.newMatch) })
          }
        }
      }
    }
  }
}

extension DFPadel.State {
  var shouldShowMatch: Bool {
    if let lastMatch = self.matches.last, lastMatch.winner == nil {
      return true
    } else {
      return false
    }
  }
}
