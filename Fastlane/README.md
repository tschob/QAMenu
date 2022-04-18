fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios unit_tests

```sh
[bundle exec] fastlane ios unit_tests
```

Runs the AllUnitTests scheme

### ios build_ios_example_app

```sh
[bundle exec] fastlane ios build_ios_example_app
```

Builds the Example-iOS app

### ios build_swiftui_ios_example_app

```sh
[bundle exec] fastlane ios build_swiftui_ios_example_app
```

Builds the Example-SwiftUI (iOS) app

### ios build_swiftui_watchos_example_app

```sh
[bundle exec] fastlane ios build_swiftui_watchos_example_app
```

Builds the Example-SwiftUI (watchOS) app

### ios build_swiftui_macos_playground_app

```sh
[bundle exec] fastlane ios build_swiftui_macos_playground_app
```

Builds the Example-SwiftUI (macOS) app

### ios build_swiftui_tvos_playground_app

```sh
[bundle exec] fastlane ios build_swiftui_tvos_playground_app
```

Builds the Example-SwiftUI (tvOS) app

### ios build_pods_integration_uikit_ios_example_app

```sh
[bundle exec] fastlane ios build_pods_integration_uikit_ios_example_app
```

Builds the Pod-Integration-iOS-UIKit example apps

### ios build_pods_integration_swiftui_ios_example_app

```sh
[bundle exec] fastlane ios build_pods_integration_swiftui_ios_example_app
```

Builds the Pod-Integration-iOS-SwiftUI example apps

### ios ship_pods

```sh
[bundle exec] fastlane ios ship_pods
```

Ships Pods for the current version

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
