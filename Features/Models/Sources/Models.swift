import Foundation

public struct Player: Equatable, Identifiable {
  public typealias ID = String

  public let id: Self.ID
  public var name: String

  public init(id: String = UUID().uuidString, name: String) {
    self.id = id
    self.name = name
  }
}

public struct Team: Equatable {
  public var playerA: Player.ID
  public var playerB: Player.ID

  public init(playerA: Player.ID, playerB: Player.ID) {
    self.playerA = playerA
    self.playerB = playerB
  }
}

public enum Deuce: String, Equatable, CaseIterable {
  case advantage = "Advantage"
  case golden = "Golden point"
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
  public typealias ID = String

  public let id: Self.ID
  public let creationDate: Date
  public var teamA: Team
  public var teamB: Team
  public var deuce: Deuce
  public var sets: [PadelSet]
  public var winner: Turn?

  public init(teamA: Team, teamB: Team, deuce: Deuce) {
    self.id = UUID().uuidString
    self.creationDate = .now
    self.teamA = teamA
    self.teamB = teamB
    self.deuce = deuce
    self.sets = [.init()]
    self.winner = nil
  }
}
