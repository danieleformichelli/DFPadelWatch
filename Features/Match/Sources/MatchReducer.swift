import ComposableArchitecture
import Foundation
import Models
import Shared

public struct MatchFeature: ReducerProtocol {
  public init() {}

  public struct State: Equatable {
    var error: String?
    let match: Match

    public init(error: String? = nil, match: Match) {
      self.error = error
      self.match = match
    }
  }

  public enum Action: FeatureAction, Equatable {
    public enum Input: Equatable {
      case didTapAddPoint(Turn)
      case didTapUndo
    }

    public enum Module: Equatable {
      case handleClearError(Match)
    }

    public enum Delegate: Equatable {
      case handleUpdateMatch(Match)
    }

    case input(Input)
    case module(Module)
    case delegate(Delegate)
  }

  enum Error: LocalizedError {
    case canNotUndo
    case canNotAddPointsToFinishedGame
    case canNotAddPointsToFinishedMatch
    case canNotAddPointsToFinishedSet

    var errorDescription: String {
      switch self {
      case .canNotUndo:
        return "There is nothing to undo!"
      case .canNotAddPointsToFinishedGame:
        return "Can't add more points, game is over!"
      case .canNotAddPointsToFinishedMatch:
        return "Can't add more points, match is over!"
      case .canNotAddPointsToFinishedSet:
        return "Can't add more points, set is over!"
      }
    }
  }

  public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    do {
      switch action {
      case .input(let inputAction):
        switch inputAction {
        case .didTapAddPoint(let turn):
          var updatedMatch = state.match
          try updatedMatch.addPoint(to: turn)
          return Effect(value: Action.delegate(.handleUpdateMatch(updatedMatch)))
        case .didTapUndo:
          var updatedMatch = state.match
          if !updatedMatch.undo() {
            throw Error.canNotUndo
          }
          return Effect(value: Action.delegate(.handleUpdateMatch(updatedMatch)))
        }
      case .module(let moduleAction):
        switch moduleAction {
        case .handleClearError:
          state.error = nil
          return .none
        }
      case .delegate:
        return .none
      }
    } catch let error {
      state.error = "\(error)"
      return .none
    }

  }
}

extension Match {
  private var gamesCount: Int {
    return self.sets.flatMap(\.games).count
  }

  var servingTeam: Turn {
    if let lastSet = self.sets.last, lastSet.isAtTieBreak {
      let pointsCount = lastSet.games.last?.points.count ?? 0
      // `a` serves first once, then 2 points for each player of each team
      switch pointsCount {
      case 0, 3, 4, 7, 8, 11, 12, 15, 16, 19:
        return .a
      case 1, 2, 5, 6, 9, 10, 13, 14, 17, 18:
        return .b
      default:
        fatalError("Tie break has a maximum of 20 points")
      }
    } else {
      return (self.gamesCount - 1).isMultiple(of: 2) ? .a : .b
    }
  }

  var servingPlayer: Turn {
    if let lastSet = self.sets.last, lastSet.isAtTieBreak {
      let pointsCount = lastSet.games.last?.points.count ?? 0
      // `a` serves first once, then 2 points for each player of each team
      switch pointsCount {
      case 0, 1, 2, 7, 8, 9, 10, 15, 16, 17, 18:
        return .a
      case 3, 4, 5, 6, 11, 12, 13, 14, 19:
        return .b
      default:
        fatalError("Tie break has a maximum of 20 points")
      }
    } else {
      return ((self.gamesCount - 1) / 2).isMultiple(of: 2) ? .a : .b
    }
  }

  mutating func addPoint(to turn: Turn) throws {
    guard self.winner == nil else {
      throw MatchFeature.Error.canNotAddPointsToFinishedMatch
    }
    try self.sets[self.sets.count - 1].addPoint(to: turn, deuce: self.deuce)
    if self.sets.last?.winner != nil {
      if let winner = self.winner() {
        self.winner = winner
      } else {
        self.sets.append(.init())
      }
    }
  }

  mutating func undo() -> Bool {
    if self.sets[self.sets.count - 1].undo() {
      return true
    } else {
      guard self.sets.count > 1 else {
        return false
      }

      self.sets.removeLast()
      return self.undo()
    }
  }

  func winner() -> Turn? {
    let aSets = self.sets.filter { $0.winner(deuce: self.deuce) == .a }.count
    let bSets = self.sets.filter { $0.winner(deuce: self.deuce) == .b }.count
    if Self.winner(first: aSets, other: bSets) {
      return .a
    } else if Self.winner(first: bSets, other: aSets) {
      return .b
    } else {
      return nil
    }
  }

  static func winner(first: Int, other: Int) -> Bool {
    return first >= 2
  }
}

extension PadelSet {
  var isAtTieBreak: Bool {
    return self.games.count == 13
  }

  mutating func addPoint(to turn: Turn, deuce: Deuce) throws {
    guard self.winner == nil else {
      throw MatchFeature.Error.canNotAddPointsToFinishedSet
    }
    try self.games[self.games.count - 1].addPoint(to: turn, deuce: deuce, tieBreak: self.isAtTieBreak)
    if self.games.last?.winner != nil {
      if let winner = self.winner(deuce: deuce) {
        self.winner = winner
      } else {
        self.games.append(.init())
      }
    }
  }

  mutating func undo() -> Bool {
    self.winner = nil
    if self.games[self.games.count - 1].undo() {
      return true
    } else {
      self.games.removeLast()
      if !self.games.isEmpty {
        return self.undo()
      } else {
        return false
      }
    }
  }

  func winner(deuce: Deuce) -> Turn? {
    let aGames = self.games.enumerated().filter { index, game in
      let tieBreak = index == 12
      return game.winner(deuce: deuce, tieBreak: tieBreak) == .a
    }.count
    let bGames = self.games.enumerated().filter { index, game in
      let tieBreak = index == 12
      return game.winner(deuce: deuce, tieBreak: tieBreak) == .b
    }.count
    if Self.winner(first: aGames, other: bGames) {
      return .a
    } else if Self.winner(first: bGames, other: aGames) {
      return .b
    } else {
      return nil
    }
  }

  static func winner(first: Int, other: Int) -> Bool {
    return (first >= 6 && first - other >= 2) || first >= 7
  }
}

extension Game {
  mutating func addPoint(to turn: Turn, deuce: Deuce, tieBreak: Bool) throws {
    guard self.winner == nil else {
      throw MatchFeature.Error.canNotAddPointsToFinishedGame
    }
    self.points.append(turn)
    if let winner = self.winner(deuce: deuce, tieBreak: tieBreak) {
      self.winner = winner
    }
  }

  mutating func undo() -> Bool {
    self.winner = nil
    guard !self.points.isEmpty else {
      return false
    }
    self.points.removeLast()
    return true
  }

  func winner(deuce: Deuce, tieBreak: Bool) -> Turn? {
    let aPoints = self.points.filter { $0 == .a }.count
    let bPoints = self.points.count - aPoints
    if Self.winner(first: aPoints, other: bPoints, deuce: deuce, tieBreak: tieBreak) {
      return .a
    } else if Self.winner(first: bPoints, other: aPoints, deuce: deuce, tieBreak: tieBreak) {
      return .b
    } else {
      return nil
    }
  }

  static func winner(first: Int, other: Int, deuce: Deuce, tieBreak: Bool) -> Bool {
    if tieBreak {
      return (first >= 7 && first - other >= 2) || first >= 10
    } else {
      switch deuce {
      case .advantage:
        return first >= 4 && first - other >= 2
      case .golden:
        return first >= 4
      }
    }
  }
}
