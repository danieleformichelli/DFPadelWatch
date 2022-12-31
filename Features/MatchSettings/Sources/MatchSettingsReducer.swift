import ComposableArchitecture
import Foundation
import Models

public struct MatchSettingsFeature: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    var match: Match
    let players: [Player.ID: Player]

    public init(match: Match, players: [Player.ID: Player]) {
      self.match = match
      self.players = players
    }
  }

  public enum Action: Equatable {
    case didSetPlayer(team: Turn, player: Turn, id: Player.ID)
    case didSetDeuce(Deuce)
    case didTapSave(Match)
    case didTapCancel
    case didTapDelete(Match.ID)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .didSetPlayer(let team, let player, let id):
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
    case .didSetDeuce(let deuce):
      state.match.deuce = deuce
      return .none
    case .didTapSave, .didTapCancel, .didTapDelete:
      // handled outside
      return .none
    }
  }
}
