# Changelog

## TBA

#### Breaking Changes

* [QAMenu] Group items and picker options are now wrapped in the new `Delayed` type (MR TBA)

#### Enhancements

* [QAMenu] Added new item type `EditableStringItem` which allows to edit Strings (PR #9)
* [QAMenu] Group items and picker options loading can now be delayed until they are presented on the screen (PR TBA)
* [QAMenu] New item `ProgressItem` can be used to show a progress (and error message) (PR TBA)
* [QAMenuUIKit] `EditableStringItem`s can be edited with a simple UIAlertViewController (PR #9)
* [QAMenuUIKit] New item `ProgressItemView` (MR TBA)

#### Bug Fixes

* [QAMenu] Marked some additional closure as escaping (PR TBA)

## 0.3.0

#### Breaking Changes

* [QAMenu] Renamed parameter `isSearchable` to `isPaneSearchable` in `Item.asChildPaneItem()` (PR #6)
* [QAMenu] Removed parameter `trigger` from `QAMenu()` in favor of `QAMenu.setTrigger()` (PR #7)
* [QAMenu] Renamed `QAMenuDismissBehavior` to `QAMenu.DismissBehavior()` (PR #7)
* [QAMenuCatalog] `QAMenu.Catalog.all()` requires now a `QAMenu` instance as parameter (PR #7)
* [QAMenuCatalog] `QAMenu.Catalog.Preferences()` defaults now to show the custom preferences on a child pane (PR #8)

#### Enhancements

* [QAMenu] Added missing `asChildPaneItem()` options to create items with values (PR #6)
* [QAMenu] Allow to pass the root pane after initializing `QAMenu` with `setRootPane()` (PR #7)
* [QAMenu] `QAMenu.Trigger` configuration is now backed by NSUserDefaults  (PR #7)
* [QAMenu] Exposed configuration option `QAMenu.DismissBehavior` (PR #7)
* [QAMenuCatalog] Added group and items to be able to see and modify the QAMenu configuration (PR #7)
* [QAMenuCatalog] Add option to `QAMenu.Catalog.Preferences()`to show custom preferences on a child pane (PR #8)

#### Bug Fixes

* [QAMenuUIKit] Fix not adapting layout when using split screen (PR #2)
* [QAMenuUIKit] Update status bar color when the app is showing a modal screen (PR #2)


## 0.2.0

#### Breaking Changes

* None

#### Enhancements

* [QAMenuUIKit] Remove custom navigate to root pane button and use back button titles again (PR #1)

#### Bug Fixes

* None


## 0.1.0

Initial release 🎉

- - - 

## Template

#### Breaking Changes

* None

#### Enhancements

* None

#### Bug Fixes

* None
