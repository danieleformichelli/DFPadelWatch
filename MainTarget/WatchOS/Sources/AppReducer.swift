import ComposableArchitecture
import Home
import MatchTracker
import MatchSettingsEditor
import Models
import Players

struct DFPadel: ReducerProtocol {
  struct State: Equatable {
    var matches: [Match.ID: Match]
    var matchSettings: MatchSettings?
    var players: [Player.ID: Player]
    var shouldShowHistory: Bool
    var shouldShowPlayers: Bool

    init() {
      self.matches = [:]
      self.matchSettings = nil
      self.players = [:]
      self.shouldShowHistory = false
      self.shouldShowPlayers = false
    }
  }

  enum Action: Equatable {
    case home(Home.Action)
    case match(MatchTracker.Action)
    case matchSettings(MatchSettingsEditor.Action)
    case players(Players.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .home:
        return .none
      case .match(let matchAction):
        switch matchAction {
        case .input, .module:
          return .none
        case .delegate(let delegateAction):
          switch delegateAction {
          case .handleUpdateMatch(let match):
            state.matches[match.id] = match
            return .none
          }
        }
      case .matchSettings(let matchSettingsAction):
        switch matchSettingsAction {
        case .input:
          return .none
        case .delegate(let delegateAction):
          switch delegateAction {
          case .handleSaveMatch(let match):
            state.matchSettings = nil
            state.matches[match.id] = match
          case .handleCancelEditMatch:
            state.matchSettings = nil
          case .handleDeleteMatch(let matchID):
            state.matchSettings = nil
            state.matches[matchID] = nil
          }
          return .none
        }
      case .players(let playersAction):
        switch playersAction {
        case .input:
          return .none
        case .delegate(let delegateAction):
          switch delegateAction {
          case .handleSavePlayers(let players):
            state.players = players
            state.shouldShowPlayers = false
          case .handleGoBack:
            state.shouldShowPlayers = false
          }
          return .none
        }
      }
    }
  }
}
