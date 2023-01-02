import ComposableArchitecture
import Foundation
import Models
import Shared

public struct Players: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    public var players: [Player.ID: Player]
    var newPlayer: Player
    public var shouldShowPlayers: Bool

    public init(players: [Player.ID: Player], shouldShowPlayers: Bool) {
      self.players = players
      self.newPlayer = .init(name: "")
      self.shouldShowPlayers = shouldShowPlayers
    }
  }

  public enum Action: FeatureAction, Equatable {
    public typealias ModuleAction = Never
    public typealias DelegateAction = Never

    public enum Input: Equatable {
      case didChangePlayer(Player)
      case didTapGoBack
    }

    case input(Input)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .input(let inputAction):
      switch inputAction {
      case .didChangePlayer(let player):
        state.players[player.id] = player.name != "" ? player : nil
        if player.id == state.newPlayer.id {
          state.newPlayer = .init(name: "")
        }
        return .none
      case .didTapGoBack:
        state.shouldShowPlayers = false
        return .none
      }
    }
  }
}
