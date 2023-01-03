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
        List {
          ForEach(.constant(viewStore.sortedEditingPlayers)) { player in
            Text(player.name.wrappedValue)
          }
          .onDelete { indexRange in
            if let index = indexRange.first {
              let deletedID = viewStore.sortedEditingPlayers[index].id
              viewStore.send(.input(.didDeletePlayer(deletedID)))
            }
          }
          TextField(
            "Add player",
            text: viewStore.binding(
              get: \.newPlayer,
              send: { .input(.didAddPlayer($0)) }
            )
          )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        HStack {
          Button("Save") {
            viewStore.send(.input(.didTapSave))
          }
          Button("Cancel") {
            viewStore.send(.input(.didTapCancel))
          }
        }
      }
    }
  }
}

extension Players.State {
  var sortedEditingPlayers: [Player] {
    return self.editingPlayers?.values.sorted { $0.name < $1.name } ?? []
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
            editingPlayers: [
              "D": .init(name: "DF"),
              "G": .init(name: "GIF"),
              "M": .init(name: "MC"),
            ],
            newPlayer: ""
          ),
          reducer: Players()
        )
      )
    }
}
