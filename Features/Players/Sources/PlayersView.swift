import ComposableArchitecture
import Models
import SwiftUI

public struct PlayersView: View {
  let store: StoreOf<Players>

  public init(store: StoreOf<Players>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      VStack {
        List(viewStore.players.values.sorted { $0.name < $1.name } + [viewStore.newPlayer]) { player in
          TextField(
            "Add player",
            text: viewStore.binding(
              get: { _ in player.name },
              send: { .input(.didChangePlayer(.init(id: player.id, name: $0))) }
            )
          )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        HStack {
          Button("Go back") {
            viewStore.send(.input(.didTapGoBack))
          }
        }
      }
    }
  }
}

struct PlayersView_Previews: PreviewProvider {
    static var previews: some View {
      PlayersView(
        store: .init(
          initialState: .init(
            players: [
              "D": .init(name: "DF"),
              "G": .init(name: "GIF"),
              "M": .init(name: "MC"),
            ],
            shouldShowPlayers: true
          ),
          reducer: Players()
        )
      )
    }
}
