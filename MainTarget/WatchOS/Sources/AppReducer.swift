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
      Reduce { state, action in
        switch action {
        case .home(let homeAction):
          switch homeAction {
          case .input:
            return .none
          case .delegate(let homeDelegateAction):
            switch homeDelegateAction {
            case .handleStartNewMath:
              state.shouldShowMatchSettings = .init(teamA: .init(playerA: "", playerB: ""), teamB: .init(playerA: "", playerB: ""), deuce: .golden)
              return .none
            case .handleShowHistory:
              return .none
            case .handleShowPlayers:
              state.playersState.shouldShowPlayers = true
              return .none
            }
          }
        case .matchTracker, .matchSettingsEditor, .players:
          return .none
        }
      }
      Scope(state: \.home, action: /Action.home) {
        Home()
      }
      Scope(state: \.playersState, action: /Action.players) { Players() }
    }
    .ifLet(\.matchTracker, action: /Action.matchTracker) { MatchTracker() }
    .ifLet(\.matchSettingsEditor, action: /Action.matchSettingsEditor) { MatchSettingsEditor() }
  }
}
