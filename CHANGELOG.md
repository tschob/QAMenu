# Changelog

## Next Release

#### Breaking Changes

* [ALL] Increase minimum iOS version to 13.0 (PR #29)
* [ALL] Update project to Xcode 15.4 and Swift 5.10 (PR #29)
* [QAMenu] Remove `QAMenu` parameter from the `ButtonItem.action` closure. Use `presentDialog` on the item instead of making use of the `QAMenu` instance (PR #26)
* [QAMenu] Remove `SelectionOutcome.action((QAMenu)`, use `SelectionOutcome.custom()` instead (PR #26)
* [QAMenu] Replace `onShouldEdit` closure with `onEdit` and `onEditSubject` (PR #27)

#### Enhancements

* [QAMenuExampleItems] Move internal QAMenu example configurations into reusable framework (PR #25)
* [QAMenu] Add `presentDialog` function to trigger dialogs without accessing the observable itself (PR #26)
* [QAMenuUIKit] Add `asUIAlertController` extension for `DialogContent` (PR #26)
* [QAMenu] Add `PassthroughSubject` alternative for all `ObservableEvent` properties (PR #27)

#### Bug Fixes

* None

## 0.6.0

#### Breaking Changes

* None

#### Enhancements

* [QAMenu] Conform to `DialogTrigger` in all Items and Groups (PR #23)

#### Bug Fixes

* None

## 0.5.1

#### Breaking Changes

* None

#### Enhancements

* None

#### Bug Fixes

* [QAMenuUIKit] Fix ignored `DialogContent.closeButtonTitle` usage (PR #22)

## 0.5.0

#### Breaking Changes

* [QAMenu] Replaced init parameter `layoutType ` with function `withLayoutType(...)` (PR #16)

#### Enhancements

* [QAMenuUIKit] Improved dark mode and dynamic font support (PR #14)
* [QAMenu] Added to option to specify `TextStyle` and `LineBreak` for `StringItem`, `EditableStringItem`, `PickableStringItem` and `ChildPaneItem` (PR #16)
* [QAMenuUIKit] Support new `TextAttribute`s: `TextStyle` and `LineBreak` (PR #16)
* [QAMenuUIKit] `PickableStringItemView ` only allocates now layout space for the checkmark view if the checkmark is shown (PR #17)

#### Bug Fixes

* [QAMenu] Fix duplicate back navigation if picker group is opened multiple times (PR #15)

## 0.4.0

#### Breaking Changes

* [QAMenu] `Group.items`, `ItemGroup.items` and `PickerGroup.options` are now wrapped in the new `Delayed` type (PR #10)
* [QAMenu] The parameter `isSearchable` is renamed to `isPaneSearchable` in `Group.asChildPaneItem` (PR #11)

#### Enhancements

* [QAMenu] Added new item type `EditableStringItem` which allows to edit Strings (PR #9)
* [QAMenu] `Group.items`, `ItemGroup.items` and `PickerGroup.options` loading can now be delayed until they are presented on the screen (PR #10)
* [QAMenu] New item `ProgressItem` can be used to show a progress (and error message) (PR #10)
* [QAMenu] `Pane`s can now be declared as reloadable (PR #11)
* [QAMenuUIKit] `EditableStringItem`s can be edited with a simple UIAlertViewController (PR #9)
* [QAMenuUIKit] Added view for new `ProgressItem` (PR #10)
* [QAMenuUIKit] Reloadable panes can be reloaded with pull-to-refresh (PR #11)
* [QAMenuUIKit] Toggling the visibility of the menu via a shake gesture executes a haptic feedback (PR #12)

#### Bug Fixes

* [QAMenu] Declared some additional closures as escaping (PR #10)

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
