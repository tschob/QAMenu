# QAMenuCatalog

The QAMenuCatalog contains some very generic basic items.

The complete catalog is implemented in the separate framework `QAMenuCatalog` and needs to be additionally specified when integrating the frameworks.

## Installation 

You need to import `QAMenuCatalog` if you want to make use of catalog items. To be able to do so make sure that you additionally integrate the `QAMenuCatalog` framework already.

### CocoaPods

```ruby
target '<Your Target Name>' do
    pod 'QAMenuUIKit'
    pod 'QAMenuCatalog'
end 
```

### Manual integration

To integrate QAMenu directly from the source code, follow the usual integration steps. You can use `Examples/Example-iOS` as real life example.


## AppInfo

### appVersionStringItem

### appBuildNumberStringItem

### infoPlistChildPaneItem

<img src=".images/catalog_overview_info_plist.png" height="400" />

## Device

### Accessibility.group

<img src=".images/catalog_overview_accessiblity.png" height="400" />

### Locale.group

<img src=".images/catalog_overview_locale.png" height="400" />

#### Locale.identifierStringItem

#### Locale.languageCodeStringItem

#### Locale.regionCodeStringItem

#### Locale.calendarStringItem

#### Locale.currencyCodeStringItem

#### Locale.preferredLanguagesStringItem

## Preferences

### standardUserDefaultsChildPaneItem

<img src=".images/catalog_overview_user_defaults.png" height="400" />

### customPreferencesPListsChildPaneItems


