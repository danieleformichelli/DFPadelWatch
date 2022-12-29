import ComposableArchitecture
import Models
import SwiftUI

public struct MatchView: View {
  let store: StoreOf<MatchFeature>

  public init(store: StoreOf<MatchFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack(spacing: 10) {
        HStack {
          ScoreView(
            sets: (
              a: viewStore.match.sets.filter { $0.winner == .a }.count,
              b: viewStore.match.sets.filter { $0.winner == .b }.count
            ),
            games: (
              a: viewStore.match.sets.last!.games.filter { $0.winner == .a }.count,
              b: viewStore.match.sets.last!.games.filter { $0.winner == .b }.count)
          )
          .frame(minWidth: 0, maxWidth: .infinity)
          HStack {
            Spacer()
            Button { viewStore.send(.undo)} label: {
              Image(systemName: "arrow.uturn.backward.square")
            }
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 30, height: 30)
            Button {} label: {
              Image(systemName: "ellipsis.circle")
            }
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 30, height: 30)
          }
        }
        Spacer()
        HStack(spacing: 0) {
          Spacer()
          TeamButton(
            team: viewStore.match.teamA,
            points: viewStore.match.sets.last?.games.last?.points.filter { $0 == .a }.count ?? 0,
            tieBreak: viewStore.match.sets.last?.isAtTieBreak ?? false,
            servingPlayer: viewStore.match.servingTeam == .a ? viewStore.match.servingPlayer : nil,
            winner: viewStore.match.winner.map { $0 == .a },
            action: { viewStore.send(.point(.a)) }
          )
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          Spacer()
          TeamButton(
            team: viewStore.match.teamB,
            points: viewStore.match.sets.last?.games.last?.points.filter { $0 == .b }.count ?? 0,
            tieBreak: viewStore.match.sets.last?.isAtTieBreak ?? false,
            servingPlayer: viewStore.match.servingTeam == .b ? viewStore.match.servingPlayer : nil,
            winner: viewStore.match.winner.map { $0 == .b },
            action: { viewStore.send(.point(.b)) }
          )
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
      }
    }
  }
}

struct MatchView_Previews: PreviewProvider {
    static var previews: some View {
      MatchView(
        store: .init(
          initialState: .init(match: .init(
            teamA: .init(playerA: .init(name: "GIF"), playerB: .init(name: "MC")),
            teamB: .init(playerA: .init(name: "DF"), playerB: .init(name: "DF")),
            deuce: .golden
          )),
          reducer: MatchFeature()
        )
      )
    }
}
