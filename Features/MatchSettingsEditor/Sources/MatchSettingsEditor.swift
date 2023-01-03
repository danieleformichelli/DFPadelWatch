import ComposableArchitecture
import Foundation
import Models
import Shared

public struct MatchSettingsEditor: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    public var match: Match?
    public var matches: [Match.ID: Match]
    let players: [Player.ID: Player]

    public init(match: Match?, matches: [Match.ID: Match], players: [Player.ID: Player]) {
      self.match = match
      self.matches = matches
      self.players = players
    }
  }

  public enum Action: FeatureAction, Equatable {
    public typealias ModuleAction = Never
    public typealias DelegateAction = Never

    public enum Input: Equatable {
      case didChangePlayer(team: Turn, player: Turn, id: Player.ID)
      case didChangeDeuce(Deuce)
      case didTapSave
      case didTapCancel
      case didTapDelete
    }

    case input(Input)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .input(let inputAction):
      switch inputAction {
      case .didChangePlayer(let team, let player, let id):
        switch (team, player) {
        case (.a, .a):
          state.match?.teamA.playerA = id
        case (.a, .b):
          state.match?.teamA.playerB = id
        case (.b, .a):
          state.match?.teamB.playerA = id
        case (.b, .b):
          state.match?.teamB.playerB = id
        }
        return .none
      case .didChangeDeuce(let deuce):
        state.match?.deuce = deuce
        return .none
      case .didTapSave:
        if let match = state.match {
          state.matches[match.id] = match
        }
        state.match = nil
        return .none
      case .didTapCancel:
        state.match = nil
        return .none
      case .didTapDelete:
        if let match = state.match {
          state.matches[match.id] = nil
        }
        state.match = nil
        return .none
      }
    }
  }
}
