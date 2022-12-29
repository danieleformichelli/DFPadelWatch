public struct Player: Equatable {
  public let name: String

  public init(name: String) {
    self.name = name
  }
}

public struct Team: Equatable {
  public let playerA: Player
  public let playerB: Player

  public init(playerA: Player, playerB: Player) {
    self.playerA = playerA
    self.playerB = playerB
  }
}

public enum Deuce: Equatable {
  case advantage
  case golden
}

public enum Turn: Equatable {
  case a
  case b

  public var opponent: Self {
    switch self {
    case .a:
      return .b
    case .b:
      return .a
    }
  }
}

public struct Game: Equatable {
  public var points: [Turn]
  public var winner: Turn?

  public init() {
    self.points = []
    self.winner = nil
  }
}

public struct PadelSet: Equatable {
  public var games: [Game]
  public var winner: Turn?

  public init() {
    self.games = [.init()]
    self.winner = nil
  }
}

public struct Match: Equatable {
  public let teamA: Team
  public let teamB: Team
  public let deuce: Deuce
  public var sets: [PadelSet]
  public var winner: Turn?

  public init(teamA: Team, teamB: Team, deuce: Deuce) {
    self.teamA = teamA
    self.teamB = teamB
    self.deuce = deuce
    self.sets = [.init()]
    self.winner = nil
  }
}
