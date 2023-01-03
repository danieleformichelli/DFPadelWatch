import Home
import MatchTracker
import MatchSettingsEditor
import Models
import Players

extension DFPadel {
  struct State: Equatable {
    var matches: [Match.ID: Match]
    var playersState: Players.State
    var shouldShowMatchSettings: Match?
    var shouldShowHistory: Bool

    var players: [Player.ID: Player] {
      return self.playersState.players
    }

    init() {
      self.matches = [:]
      self.playersState = .init()
      self.shouldShowMatchSettings = nil
      self.shouldShowHistory = false
    }
  }
}

extension DFPadel.State {
  var home: Home.State {
    get {
      return .init()
    }
    set {
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
