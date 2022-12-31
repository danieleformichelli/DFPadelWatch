import ComposableArchitecture
import Models
import SwiftUI

public struct MatchSettingsView: View {
  let store: StoreOf<MatchSettingsFeature>

  public init(store: StoreOf<MatchSettingsFeature>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      ScrollView {
        HStack {
          VStack {
            Text("Team A")
            Picker(
              selection: viewStore.binding(
                get: { $0.players[$0.match.teamA.playerA]?.name ?? "Player A" },
                send: { .didSetPlayer(team: .a, player: .a, id: $0) }
              ),
              label: EmptyView()
            ) {
              ForEach(viewStore.state.players.values.sorted(by: { $0.name < $1.name }), id: \.id) { player in
                HStack {
                  Text(player.name)
                  Spacer()
                }
              }
            }
            .labelsHidden()
            .pickerStyle(.navigationLink)
            .frame(height: 50)
            Picker(
              selection: viewStore.binding(
                get: { $0.players[$0.match.teamA.playerB]?.name ?? "Player B" },
                send: { .didSetPlayer(team: .a, player: .b, id: $0) }
              ),
              label: EmptyView()
            ) {
              ForEach(viewStore.state.players.values.sorted(by: { $0.name < $1.name }), id: \.id) { player in
                HStack {
                  Text(player.name)
                  Spacer()
                }
              }
            }
            .pickerStyle(.navigationLink)
            .frame(height: 50)
          }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
          VStack {
            Text("Team B")
            Picker(
              selection: viewStore.binding(
                get: { $0.players[$0.match.teamB.playerA]?.name ?? "Player A" },
                send: { .didSetPlayer(team: .b, player: .a, id: $0) }
              ),
              label: EmptyView()
            ) {
              ForEach(viewStore.state.players.values.sorted(by: { $0.name < $1.name }), id: \.id) { player in
                HStack {
                  Text(player.name)
                  Spacer()
                }
              }
            }
            .pickerStyle(.navigationLink)
            .frame(height: 50)
            Picker(
              selection: viewStore.binding(
                get: { $0.players[$0.match.teamB.playerB]?.name ?? "Player B" },
                send: { .didSetPlayer(team: .b, player: .b, id: $0) }
              ),
              label: EmptyView()
            ) {
              ForEach(viewStore.state.players.values.sorted(by: { $0.name < $1.name }), id: \.id) { player in
                HStack {
                  Text(player.name)
                  Spacer()
                }
              }
            }
            .pickerStyle(.navigationLink)
            .frame(height: 50)
          }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
        Picker("Deuce", selection: viewStore.binding(
          get: \.match.deuce,
          send: { .didSetDeuce($0) }
        )) {
          ForEach(Deuce.allCases, id: \.self) { deuce in
            HStack {
              Text(deuce.rawValue)
              Spacer()
            }
          }
        }
        .pickerStyle(.navigationLink)
        .frame(height: 50)
        HStack {
          Button { viewStore.send(.didTapSave(viewStore.match)) } label: {
            Image(systemName: "checkmark.circle.fill")
              .foregroundColor(.green)
          }
          Button { viewStore.send(.didTapCancel) } label: {
            Image(systemName: "arrow.uturn.backward")
              .foregroundColor(.secondary)
          }
          Button { viewStore.send(.didTapDelete(viewStore.match.id)) } label: {
            Image(systemName: "trash.fill")
              .foregroundColor(.red)
          }
        }
      }
    }
  }
}

struct MatchSettingsView_Previews: PreviewProvider {
    static var previews: some View {
      MatchSettingsView(
        store: .init(
          initialState: .init(
            match: .init(
              teamA: .init(playerA: "G", playerB: "M"),
              teamB: .init(playerA: "D", playerB: "D"),
              deuce: .golden
            ),
            players: [
              "D": .init(name: "DF"),
              "G": .init(name: "GIF"),
              "M": .init(name: "MC"),
            ]
          ),
          reducer: MatchSettingsFeature()
        )
      )
    }
}
