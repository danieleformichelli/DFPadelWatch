import ProjectDescription

let dependencies = Dependencies(
  swiftPackageManager: .init(
    [
      .remote(url: "git@github.com:pointfreeco/swift-composable-architecture.git", requirement: .upToNextMajor(from: "0.47.2")),
      .remote(url: "git@github.com:pointfreeco/xctest-dynamic-overlay.git", requirement: .upToNextMajor(from: "0.7.0")),
    ],
    productTypes: [
      "CasePaths": .framework,
      "Clocks": .framework,
      "CombineSchedulers": .framework,
      "ComposableArchitecture": .framework,
      "CustomDump": .framework,
      "Dependencies": .framework,
      "IdentifiedCollections": .framework,
      "OrderedCollections": .framework,
      "XCTestDynamicOverlay": .framework,
      "_SwiftUINavigationState": .framework,
    ]
  ),
  platforms: [.iOS, .watchOS]
)
