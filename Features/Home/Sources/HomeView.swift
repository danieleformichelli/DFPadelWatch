import ComposableArchitecture
import Models
import SwiftUI

public struct HomeView: View {
  let store: StoreOf<Home>

  public init(store: StoreOf<Home>) {
    self.store = store
  }

  public var body: some View {
    WithViewStore(self.store) { viewStore in
      Button("New match", action: { viewStore.send(.input(.didTapNewMatch)) })
      Button("Players", action: { viewStore.send(.input(.didTapPlayers)) })
      Button("History", action: { viewStore.send(.input(.didTapHistory)) })
    }
  }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
      HomeView(
        store: .init(
          initialState: .init(),
          reducer: Home()
        )
      )
    }
}
