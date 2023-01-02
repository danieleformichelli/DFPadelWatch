import ComposableArchitecture
import Foundation
import Models
import Shared

public struct MatchSettingsEditor: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    var match: Match
    let players: [Player.ID: Player]

    public init(match: Match, players: [Player.ID: Player]) {
      self.match = match
      self.players = players
    }
  }

  public enum Action: FeatureAction, Equatable {
    public typealias ModuleAction = Never

    public enum Input: Equatable {
      case didChangePlayer(team: Turn, player: Turn, id: Player.ID)
      case didChangeDeuce(Deuce)
      case didTapSave
      case didTapCancel
      case didTapDelete
    }

    public enum Delegate: Equatable {
      case handleSaveMatch(Match)
      case handleCancelEditMatch
      case handleDeleteMatch(Match.ID)
    }

    case input(Input)
    case delegate(Delegate)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .input(let inputAction):
      switch inputAction {
      case .didChangePlayer(let team, let player, let id):
        switch (team, player) {
        case (.a, .a):
          state.match.teamA.playerA = id
        case (.a, .b):
          state.match.teamA.playerB = id
        case (.b, .a):
          state.match.teamB.playerA = id
        case (.b, .b):
          state.match.teamA.playerB = id
        }
        return .none
      case .didChangeDeuce(let deuce):
        state.match.deuce = deuce
        return .none
      case .didTapSave:
        return Effect(value: .delegate(.handleSaveMatch(state.match)))
      case .didTapCancel:
        return Effect(value: .delegate(.handleCancelEditMatch))
      case .didTapDelete:
        return Effect(value: .delegate(.handleDeleteMatch(state.match.id)))
      }
    case .delegate:
      return .none
    }
  }
}
