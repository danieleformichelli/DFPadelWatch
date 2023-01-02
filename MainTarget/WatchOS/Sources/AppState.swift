import Home
import MatchTracker
import MatchSettingsEditor
import Models
import Players

extension DFPadel {
  struct State: Equatable {
    var matches: [Match.ID: Match]
    var players: [Player.ID: Player]
    var shouldShowMatchSettings: Match?
    var shouldShowHistory: Bool
    var shouldShowPlayers: Bool

    init() {
      self.matches = [:]
      self.players = [:]
      self.shouldShowMatchSettings = nil
      self.shouldShowHistory = false
      self.shouldShowPlayers = false
    }
  }
}

extension DFPadel.State {
  var home: Home.State {
    get {
      return .init(
        shouldShowMatchSettings: self.shouldShowMatchSettings,
        shouldShowHistory: self.shouldShowHistory,
        shouldShowPlayers: self.shouldShowPlayers
      )
    }
    set {
      self.shouldShowMatchSettings = newValue.shouldShowMatchSettings
      self.shouldShowHistory = newValue.shouldShowHistory
      self.shouldShowPlayers = newValue.shouldShowPlayers
    }
  }
}

extension DFPadel.State {
  var matchSettingsEditor: MatchSettingsEditor.State? {
    get {
      guard let match = self.shouldShowMatchSettings else { return nil }
      return .init(match: match, matches: self.matches, players: self.players)
    }
    set {
      guard let newValue = newValue else { return }
      self.shouldShowMatchSettings = newValue.match
      self.matches = newValue.matches
    }
  }
}

extension DFPadel.State {
  var matchTracker: MatchTracker.State? {
    get {
      guard let currentMatch = self.currentMatch else {
        return nil
      }
      return .init(error: nil, match: currentMatch)
    }
    set {
      guard let newValue = newValue else {
        return
      }

      self.matches[newValue.match.id] = newValue.match
      self.shouldShowMatchSettings = newValue.shouldShowMatchSettings
    }
  }
}

extension DFPadel.State {
  var playersState: Players.State {
    get {
      return .init(players: self.players, shouldShowPlayers: self.shouldShowPlayers)
    }
    set {
      self.players = newValue.players
      self.shouldShowPlayers = newValue.shouldShowPlayers
    }
  }
}
