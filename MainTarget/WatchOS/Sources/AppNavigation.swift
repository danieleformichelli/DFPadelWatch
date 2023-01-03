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
          if let matchSettingsEditor = viewStore.matchSettingsEditor {
            MatchSettingsEditorView(store: self.store.scope(
              state: { _ in matchSettingsEditor },
              action: { .matchSettingsEditor($0) }
            ))
          } else if viewStore.playersState.shouldShowPlayers {
            PlayersView(store: self.store.scope(
              state: \.playersState,
              action: { .players($0) }
            ))
          } else if let match = viewStore.currentMatch {
            MatchTrackerView(store: self.store.scope(
              state: { _ in .init(match: match) },
              action: { .matchTracker($0) }
            ))
          } else if let home = viewStore.home {
            HomeView(store: self.store.scope(state: { _ in home }, action: { .home($0) }))
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
}
