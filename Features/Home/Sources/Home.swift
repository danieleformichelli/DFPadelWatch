import ComposableArchitecture
import Foundation
import Models
import Shared

public struct Home: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    public init() {}
  }

  public enum Action: FeatureAction, Equatable {
    public typealias ModuleAction = Never

    public enum Input: Equatable {
      case didTapNewMatch
      case didTapHistory
      case didTapPlayers
    }

    public enum Delegate: Equatable {
      case handleStartNewMath
      case handleShowHistory
      case handleShowPlayers
    }

    case input(Input)
    case delegate(Delegate)
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .input(let inputAction):
      switch inputAction {
      case .didTapNewMatch:
        return Effect(value: .delegate(.handleStartNewMath))
      case .didTapHistory:
        return Effect(value: .delegate(.handleShowHistory))
      case .didTapPlayers:
        return Effect(value: .delegate(.handleShowPlayers))
      }
    case .delegate:
      return .none
    }
  }
}
