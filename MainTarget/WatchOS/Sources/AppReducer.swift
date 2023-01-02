import ComposableArchitecture
import Home
import MatchTracker
import MatchSettingsEditor
import Models
import Players

struct DFPadel: ReducerProtocol {
  enum Action: Equatable {
    case home(Home.Action)
    case matchTracker(MatchTracker.Action)
    case matchSettingsEditor(MatchSettingsEditor.Action)
    case players(Players.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    CombineReducers {
      Scope(state: \.home, action: /Action.home) {
        Home()
      }
      Scope(state: \.playersState, action: /Action.players) { Players() }
    }
    .ifLet(\.matchTracker, action: /Action.matchTracker) { MatchTracker() }
    .ifLet(\.matchSettingsEditor, action: /Action.matchSettingsEditor) { MatchSettingsEditor() }
  }
}
