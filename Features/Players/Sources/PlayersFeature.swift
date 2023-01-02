import ComposableArchitecture
import Foundation
import Models
import Shared

public struct PlayersFeature: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    var players: [Player.ID: Player]
    var newPlayer: Player

    public init(players: [Player.ID: Player]) {
      self.players = players
      self.newPlayer = .init(name: "")
    }
  }

  public enum Action: FeatureAction, Equatable {
    public typealias ModuleAction = Never

    public enum Input: Equatable {
      case didChangePlayer(Player)
      case didTapSave
      case didTapGoBack
    }

    public enum Delegate: Equatable {
      case handleSavePlayers([Player.ID: Player])
      case handleGoBack
    }

    case input(Input)
    case delegate(Delegate)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .input(let inputAction):
      switch inputAction {
      case .didChangePlayer(let player):
        if player.id == state.newPlayer.id {
          state.newPlayer.name = player.name
        } else {
          state.players[player.id] = player.name != "" ? player : nil
        }
        return .none
      case .didTapSave:
        return Effect(value: .delegate(.handleSavePlayers(state.players)))
      case .didTapGoBack:
        return Effect(value: .delegate(.handleGoBack))
      }
    case .delegate:
      return .none
    }
  }
}
