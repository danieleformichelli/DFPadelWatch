import ComposableArchitecture
import Match
import Models

struct DFPadel: ReducerProtocol {
  struct State: Equatable {
    var matches: [Match]
  }

  enum Action: Equatable {
    case newMatch
    case match(MatchFeature.Action)
  }

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .newMatch:
      state.matches.append(.init(
        teamA: .init(playerA: .init(name: "DF"), playerB: .init(name: "DF")),
        teamB: .init(playerA: .init(name: "GIF"), playerB: .init(name: "MC")),
        deuce: .golden
      ))
      return .none
    case .match:
      return .none
    }
  }
}
