# Changelog

## TBA

#### Breaking Changes

* [QAMenu] Renamed parameter `isSearchable` to `isPaneSearchable` in `Item.asChildPaneItem()` (MR #6)
* [QAMenu] Removed parameter `trigger` from `QAMenu()` in favor of `QAMenu.setTrigger()` (MR #7)
* [QAMenu] Renamed `QAMenuDismissBehavior` to `QAMenu.DismissBehavior()` (MR #7)
* [QAMenuCatalog] `QAMenu.Catalog.all()` requires now a `QAMenu` instance as parameter (MR #7)

#### Enhancements

* [QAMenu] Added missing `asChildPaneItem()` options to create items with values (MR #6)
* [QAMenu] Allow to pass the root pane after initializing `QAMenu` with `setRootPane()` (MR #7)
* [QAMenu] `QAMenu.Trigger` configuration is now backed by NSUserDefaults  (MR #7)
* [QAMenu] Exposed configuration option `QAMenu.DismissBehavior` (MR #7)
* [QAMenuCatalog] Added group and items to be able to see and modify the QAMenu configuration (MR #7)

#### Bug Fixes

* [QAMenuUIKit] Fix not adapting layout when using split screen (MR #2)
* [QAMenuUIKit] Update status bar color when the app is showing a modal screen (MR #2)


## 0.2.0

#### Breaking Changes

* None

#### Enhancements

* [QAMenuUIKit] Remove custom navigate to root pane button and use back button titles again (MR #1)

#### Bug Fixes

* None


## 0.1.0

Initial release 🎉