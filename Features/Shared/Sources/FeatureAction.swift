import Foundation

public protocol FeatureAction<InputAction> {
  /// The actions sent from user interactions
  associatedtype InputAction
  /// The internal modules actions
  associatedtype ModuleAction
  /// The actions that are meant to be send from the module and handled by the containing module
  associatedtype DelegateAction

  /// The input actions
  static func input(_: InputAction) -> Self

  /// The internal modules actions
  static func module(_: ModuleAction) -> Self

  /// The module delegate actions
  static func delegate(_: DelegateAction) -> Self
}

extension FeatureAction where InputAction == Never {
  /// Base implementation for a feature without input actions
  public static func input(_: InputAction) -> Self {}
}

extension FeatureAction where ModuleAction == Never {
  /// Base implementation for a feature without module actions
  public static func module(_: ModuleAction) -> Self {}
}

extension FeatureAction where DelegateAction == Never {
  /// Base implementation for a feature without delegate actions
  public static func delegate(_: DelegateAction) -> Self {}
}
