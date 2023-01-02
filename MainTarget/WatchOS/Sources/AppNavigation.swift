import ComposableArchitecture
import Home
import MatchTracker
import MatchSettingsEditor
import Models
import Players
import SwiftUI

@main
struct DFPadelApp: App {
  let store = Store(initialState: .init(), reducer: DFPadel())

  public var body: some Scene {
    WindowGroup {
      WithViewStore(self.store) { viewStore in
        Group {
          if let match = viewStore.shouldShowMatchSettings {
            MatchSettingsEditorView(store: self.store.scope(
              state: { .init(match: match, players: $0.players) },
              action: { .matchSettings($0) }
            ))
          } else if viewStore.shouldShowPlayers {
            PlayersView(store: self.store.scope(
              state: { .init(players: $0.players) },
              action: { .players($0) }
            ))
          } else if let match = viewStore.currentMatch {
            MatchTrackerView(store: self.store.scope(
              state: { _ in .init(match: match) },
              action: { .match($0) }
            ))
          } else {
            HomeView(store: self.store.scope(
              state: {
                .init(
                  shouldShowMatchSettings: $0.matchSettings,
                  shouldShowHistory: $0.shouldShowHistory,
                  shouldShowPlayers: $0.shouldShowPlayers
                )
              },
              action: { .home($0) }
            ))
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
