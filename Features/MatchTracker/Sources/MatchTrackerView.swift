import ComposableArchitecture
import Models
import SwiftUI

public struct MatchTrackerView: View {
  let store: StoreOf<MatchTracker>

  public init(store: StoreOf<MatchTracker>) {
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
            Button { viewStore.send(.input(.didTapUndo)) } label: {
              Image(systemName: "arrow.uturn.backward.square")
            }
            .buttonStyle(BorderlessButtonStyle())
            .frame(width: 30, height: 30)
            Button { viewStore.send(.input(.didTapSettings)) } label: {
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
            playerA: viewStore.match.teamA.playerA,
            playerB: viewStore.match.teamB.playerB,
            points: viewStore.match.sets.last?.games.last?.points.filter { $0 == .a }.count ?? 0,
            tieBreak: viewStore.match.sets.last?.isAtTieBreak ?? false,
            servingPlayer: viewStore.match.servingTeam == .a ? viewStore.match.servingPlayer : nil,
            winner: viewStore.match.winner.map { $0 == .a },
            action: { viewStore.send(.input(.didTapAddPoint(.a))) }
          )
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          Spacer()
          TeamButton(
            playerA: viewStore.match.teamA.playerA,
            playerB: viewStore.match.teamB.playerB,
            points: viewStore.match.sets.last?.games.last?.points.filter { $0 == .b }.count ?? 0,
            tieBreak: viewStore.match.sets.last?.isAtTieBreak ?? false,
            servingPlayer: viewStore.match.servingTeam == .b ? viewStore.match.servingPlayer : nil,
            winner: viewStore.match.winner.map { $0 == .b },
            action: { viewStore.send(.input(.didTapAddPoint(.a))) }
          )
          .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
      }
    }
  }
}

struct MatchTrackerView_Previews: PreviewProvider {
    static var previews: some View {
      MatchTrackerView(
        store: .init(
          initialState: .init(match: .init(
            teamA: .init(playerA: "GIF", playerB: "MC"),
            teamB: .init(playerA: "DF", playerB: "DF"),
            deuce: .golden
          )),
          reducer: MatchTracker()
        )
      )
    }
}
