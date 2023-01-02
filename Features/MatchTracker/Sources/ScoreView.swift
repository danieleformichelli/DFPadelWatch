import SwiftUI

public struct ScoreView: View {
  let sets: (a: Int, b: Int)
  let games: (a: Int, b: Int)

  public var body: some View {
    HStack {
      VStack(alignment: .leading) {
        Text("Sets")
          .frame(alignment: .leading)
          .lineLimit(1)
          .minimumScaleFactor(0.5)
        Text("Games")
          .multilineTextAlignment(.leading)
          .lineLimit(1)
          .minimumScaleFactor(0.5)
      }

      VStack {
        HStack {
          Text("\(self.sets.a)")
            .frame(width: 15)
          Text("\(self.sets.b)")
            .frame(width: 15)
        }
        HStack {
          Text("\(self.games.a)")
            .frame(width: 15)
          Text("\(self.games.b)")
            .frame(width: 15)
        }
      }
    }
  }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
      ScoreView(
        sets: (a: 1, b: 0),
        games: (a: 2, b: 1)
      )
    }
}
