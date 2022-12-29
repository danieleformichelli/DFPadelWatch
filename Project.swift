import ProjectDescription

let models = Target(
  name: "Models",
  platform: .watchOS,
  product: .framework,
  bundleId: "DFPadel.Models",
  sources: [
    "Features/Models/Sources/**/*.swift"
  ]
)

let match = Target(
  name: "Match",
  platform: .watchOS,
  product: .framework,
  bundleId: "DFPadel.Match",
  sources: [
    "Features/Match/Sources/**/*.swift"
  ],
  dependencies: [
    .external(name: "ComposableArchitecture"),
    .target(models),
  ]
)

let matchTests = Target(
  name: "MatchTests",
  platform: .watchOS,
  product: .unitTests,
  bundleId: "DFPadel.Match.Tests",
  sources: [
    "Features/Match/Tests/**/*.swift"
  ],
  dependencies: [
    .target(match),
  ]
)

let mainTarget = Target(
  name: "DFPadelWatchOS",
  platform: .watchOS,
  product: .app,
  bundleId: "DFPadel.watchOS",
  sources: [
    "MainTarget/WatchOS/Sources/**/*.swift"
  ],
  dependencies: [
    .external(name: "ComposableArchitecture"),
    .target(match),
    .target(models),
  ],
  settings: .settings(
    base: [
      "GENERATE_INFOPLIST_FILE": true,
      "CURRENT_PROJECT_VERSION": "1.0",
      "MARKETING_VERSION": "1.0",
      "INFOPLIST_KEY_UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait",
      ],
      "INFOPLIST_KEY_WKApplication": true,
      "INFOPLIST_KEY_WKCompanionAppBundleIdentifier": "DFPadel",
      "INFOPLIST_KEY_WKRunsIndependentlyOfCompanionApp": true,
    ]
  )
)

let mainIOSTarget = Target(
  name: "DFPadel",
  platform: .iOS,
  product: .app,
  bundleId: "DFPadel",
  sources: [
    "MainTarget/iOS/Sources/**/*.swift"
  ]
)

let project = Project(
  name: "DFPadel",
  targets: [
    mainTarget,
    mainIOSTarget,
    match,
    models,
  ],
  additionalFiles: [
    "prepare.sh",
    "README.md"
  ]
)
