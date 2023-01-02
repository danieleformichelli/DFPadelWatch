import ComposableArchitecture
import Models
import SwiftUI

public struct PlayersView: View {
  let store: StoreOf<PlayersFeature>

  public init(store: StoreOf<PlayersFeature>) {
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
              send: .input(.didChangePlayer(player))
            )
          )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        HStack {
          Button("Save") {
            viewStore.send(.input(.didTapSave))
          }
          Button("Cancel") {
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
            ]
          ),
          reducer: PlayersFeature()
        )
      )
    }
}
