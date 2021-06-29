fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios unit_tests
```
fastlane ios unit_tests
```
Runs the AllUnitTests scheme
### ios build_ios_example_app
```
fastlane ios build_ios_example_app
```
Builds the Example-iOS app
### ios build_pods_integration_example_app
```
fastlane ios build_pods_integration_example_app
```
Builds the Pod-Integration example app
### ios ship_pods
```
fastlane ios ship_pods
```
Ships Pods for the current version

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
