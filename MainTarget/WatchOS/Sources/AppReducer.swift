import ComposableArchitecture
import Match
import MatchSettings
import Models
import Players

struct DFPadel: ReducerProtocol {
  struct State: Equatable {
    enum MatchSettings: Equatable {
      case newMatch
      case editMatch(Match.ID)
    }

    var matches: [Match.ID: Match]
    var matchSettings: MatchSettings?
    var players: [Player.ID: Player]
    var shouldShowPlayers: Bool

    init() {
      self.matches = [:]
      self.matchSettings = nil
      self.players = [:]
      self.shouldShowPlayers = false
    }
  }

  enum Action: Equatable {
    case didTapNewMatch
    case didTapHistory
    case didTapPlayers
    case match(MatchFeature.Action)
    case matchSettings(MatchSettingsFeature.Action)
    case players(PlayersFeature.Action)
  }

  public var body: some ReducerProtocol<State, Action> {
    Reduce { state, action in
      switch action {
      case .didTapNewMatch:
        state.matchSettings = .newMatch
        return .none
      case .didTapHistory:
        return .none
      case .didTapPlayers:
        state.shouldShowPlayers = true
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
