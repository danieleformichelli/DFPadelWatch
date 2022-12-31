import ProjectDescription

public struct Feature {
  let name: String
  let hasTests: Bool
  let dependencies: [TargetDependency]

  public init(name: String, hasTests: Bool = false, dependencies: [TargetDependency] = []) {
    self.name = name
    self.hasTests = hasTests
    self.dependencies = dependencies
  }
  
  var target: Target {
    return  Target(
      name: self.name,
      platform: .watchOS,
      product: .framework,
      bundleId: "DFPadel.\(self.name)",
      sources: [
        "Features/\(self.name)/Sources/**/*.swift"
      ],
      dependencies: self.dependencies
    )
  }

  var testTarget: Target? {
    guard self.hasTests else { return nil }
    return  Target(
      name: "\(self.name)Tests",
      platform: .watchOS,
      product: .unitTests,
      bundleId: "DFPadel.\(self.name).Tests",
      sources: [
        "Features/\(self.name)/Tests/**/*.swift"
      ],
      dependencies: [
        .target(name: self.name)
      ]
    )
  }
}

extension [Feature] {
  public var allTargets: [Target] {
    return self.flatMap {
      [$0.target] + ($0.testTarget.map { [$0] } ?? [])
    }
  }
}

extension TargetDependency {
  public static func feature(_ feature: Feature) -> Self {
    return .target(name: feature.name)
  }
}
