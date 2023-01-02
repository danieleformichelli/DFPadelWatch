import ProjectDescription
import ProjectDescriptionHelpers

let models = Feature(name: "Models")

let shared = Feature(name: "Shared")

let match = Feature(
  name: "Match",
  hasTests: true,
  dependencies: [
    .composableArchitecture,
    .feature(models),
    .feature(shared),
  ]
)

let matchSettings = Feature(
  name: "MatchSettings",
  hasTests: true,
  dependencies: [
    .composableArchitecture,
    .feature(models),
    .feature(shared),
  ]
)

let players = Feature(
  name: "Players",
  hasTests: false,
  dependencies: [
    .composableArchitecture,
    .feature(models),
    .feature(shared),
  ]
)

let allFeatures = [
  match,
  matchSettings,
  models,
  players,
  shared,
]

let mainTarget = Target(
  name: "DFPadelWatchOS",
  platform: .watchOS,
  product: .app,
  bundleId: "DFPadel.watchOS",
  sources: [
    "MainTarget/WatchOS/Sources/**/*.swift"
  ],
  dependencies: [
    .composableArchitecture,
  ] + allFeatures.map { .feature($0) },
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
  ] + allFeatures.allTargets,
  additionalFiles: [
    "prepare.sh",
    "README.md"
  ]
)
