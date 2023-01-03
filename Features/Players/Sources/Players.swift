import ComposableArchitecture
import Foundation
import Models
import Shared

public struct Players: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    public var players: [Player.ID: Player]
    var editingPlayers: [Player.ID: Player]?
    var newPlayer: String

    public var shouldShowPlayers: Bool {
      get {
        self.editingPlayers != nil
      }
      set {
        if newValue {
          self.editingPlayers = self.players
          self.newPlayer = ""
        } else {
          self.editingPlayers = nil
        }
      }
    }

    public init() {
      self.init(players: [:], editingPlayers: nil, newPlayer: "")
    }

    init(players: [Player.ID: Player], editingPlayers: [Player.ID: Player]?, newPlayer: String) {
      self.players = players
      self.editingPlayers = editingPlayers
      self.newPlayer = newPlayer
    }
  }

  public enum Action: FeatureAction, Equatable {
    public typealias ModuleAction = Never
    public typealias DelegateAction = Never

    public enum Input: Equatable {
      case didAddPlayer(String)
      case didDeletePlayer(Player.ID)
      case didTapSave
      case didTapCancel
    }

    case input(Input)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .input(let inputAction):
      switch inputAction {
      case .didAddPlayer(let name):
        guard name != "" && !(state.editingPlayers?.values.contains(where: { $0.name == name }) ?? false) else { return .none }
        let player = Player(name: name)
        state.editingPlayers?[player.id] = player
        state.newPlayer = ""
        return .none
      case .didDeletePlayer(let id):
        state.editingPlayers?[id] = nil
        return .none
      case .didTapSave:
        guard let editingPlayers = state.editingPlayers else { return .none }
        state.players = editingPlayers
        state.shouldShowPlayers = false
        return .none
      case .didTapCancel:
        state.shouldShowPlayers = false
        return .none
      }
    }
  }
}
