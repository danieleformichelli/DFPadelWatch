import ComposableArchitecture
import Match
import MatchSettings
import Models

struct DFPadel: ReducerProtocol {
  struct State: Equatable {
    enum MatchSettings: Equatable {
      case newMatch
      case editMatch(Match.ID)
    }

    var matches: [Match.ID: Match]
    var matchSettings: MatchSettings?
    var players: [Player.ID: Player]

    init() {
      self.matches = [:]
      self.matchSettings = nil
      self.players = [:]
    }
  }

  enum Action: Equatable {
    case didTapHistory
    case didTapNewMatch
    case match(MatchFeature.Action)
    case matchSettings(MatchSettingsFeature.Action)
  }

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .didTapNewMatch:
      state.matchSettings = .newMatch
      return .none
    case .didTapHistory:
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
    }
  }
}
