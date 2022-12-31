import ComposableArchitecture
import Match
import MatchSettings
import Models
import SwiftUI

@main
struct DFPadelApp: App {
  let store = Store(initialState: .init(), reducer: DFPadel())

  public var body: some Scene {
    WindowGroup {
      WithViewStore(self.store) { viewStore in
        Group {
          if let match = viewStore.shouldShowMatchSettings {
            MatchSettingsView(store: self.store.scope(
              state: { _ in .init(match: match, players: viewStore.players) },
              action: { .matchSettings($0) }
            ))
          } else if let match = viewStore.currentMatch {
            MatchView(store: .init(initialState: .init(match: match), reducer: MatchFeature()))
          } else {
            Button("New match", action: { viewStore.send(.didTapNewMatch) })
            Button("History", action: { viewStore.send(.didTapHistory) })
          }
        }
      }
    }
  }
}

extension DFPadel.State {
  var currentMatch: Match? {
    if let lastMatch = self.matches.values.sorted(by: { $0.creationDate > $1.creationDate }).last, lastMatch.winner == nil {
      return lastMatch
    } else {
      return nil
    }
  }

  var shouldShowMatchSettings: Match? {
    switch self.matchSettings {
    case .newMatch:
      return .init(teamA: .init(playerA: "", playerB: ""), teamB: .init(playerA: "", playerB: ""), deuce: .golden)
    case .editMatch(let id):
      return self.matches[id]
    case .none:
      return nil
    }
  }
}
