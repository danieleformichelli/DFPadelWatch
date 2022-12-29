import Models
import SwiftUI

public struct TeamButton: View {
  let team: Team
  let points: Int
  let tieBreak: Bool
  let servingPlayer: Turn?
  let winner: Bool?
  let action: () -> Void

  public init(team: Team, points: Int, tieBreak: Bool, servingPlayer: Turn?, winner: Bool?, action: @escaping () -> Void) {
    self.team = team
    self.points = points
    self.tieBreak = tieBreak
    self.servingPlayer = servingPlayer
    self.winner = winner
    self.action = action
  }

  var pointsValue: String {
    if let winner = self.winner {
      return winner ? "W" : "L"
    }

    guard !self.tieBreak else {
      return "\(self.points)"
    }

    switch self.points {
    case 0:
      return "0"
    case 1:
      return "15"
    case 2:
      return "30"
    case 3:
      return "40"
    case 4:
      return "A"
    default:
      return "\(self.points)"
    }
  }

  public var body: some View {
    Button(action: self.action) {
      VStack(alignment: .center) {
        Text(self.pointsValue)
          .font(.system(size: 48))
          .foregroundColor(.primary)
        Text(self.team.playerA.name).foregroundColor(self.servingPlayer == .a ? .primary : .secondary)
        Text(self.team.playerB.name).foregroundColor(self.servingPlayer == .b ? .primary : .secondary)
      }
    }
    .buttonStyle(BorderlessButtonStyle())
  }
}

struct TeamButton_Previews: PreviewProvider {
    static var previews: some View {
      TeamButton(
        team: .init(playerA: .init(name: "A"), playerB: .init(name: "B")),
        points: 2,
        tieBreak: false,
        servingPlayer: .a,
        winner: false,
        action: {}
      )
    }
}
