import ProjectDescription

extension TargetDependency {
  public static var composableArchitecture: Self {
    return .external(name: "ComposableArchitecture")
  }
  public static var xcTestDynamicOverlay: Self {
    return .external(name: "XCTestDynamicOverlay")
  }
}
