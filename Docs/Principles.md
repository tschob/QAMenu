# Principles


## #1 Be data (model) driven aka *stop worrying about UI*

When using a QAMenu, the features are important, but the UI is secondary. This is as it's not shown to end users and it can be considered as standalone part in your app - which doesn't need to follow the apps general design language. The text colors, style, font etc. shouldn't matter too much when providing a way to inspect the user defaults, reset internal apps states or showing the apps build number.

Therefore QAMenu provides data models as UI element abstractions. This results in a way lighter interface and usage. Instead of interacting with UI elements directly for each menu entry, it's preferred to exchange the links between a data model and its UI element companion or the complete renderer.

## #2 Provide the infrastructure, not the content

Each app is unique and the possible QAMenu entries vary much. Instead of providing some specialized debug helper, the goal is to provide the starting framework which is used to access mostly your very unique entries which your app needs and if needed can be used to access other specialised libraries.

A perhaps fitting description could be that QAMenu aims to be a design system for debug menus instead of a collection of debug features.

In other words: E.g. inspecting the heap is best done with Xcode directly. If you really want to do this within your app itself, you can use QAMenu to show an option to open other third-party libraries or your own code, but QAMenu itself won't implement it.

## #3 Items should be interactive

In order to effectively debug your app, a QAMenu needs to be interactive. Direct access to objects in the app's lifecycle - like your network cache, crash report, database, ... - is needed to provide meaningful debug options. Additionally the content needs be lazily loaded and if possible editable.

Mostly "static" content like the Settings.bundle provides it, is useful for settings screens, but not sufficient when providing debug options for an app.

## #4 Allow extensive customization, but optimize for default usage

QAMenu tries to achieve a customizable and modular architecture. For example it's possible to inject custom item types, screens or even the complete renderer, but it requires comparatively more code and knowledge.

The public API makes the default usage convenient to use and thereby tries to promote it. This is heavily connected to principle 1.

### #4.1 Use composition whenever possible 

Part of the "default" usage is to use composition to achieve specialized screens instead of working with completely specialized screen types. For example a screen which shows all NSUserDefault entries can be easily achieved by composing multi line string items in a searchable pane which consists of a single group - there is not need to introduce a dedicated screen type for this.

## #5 Keep it focused on one purpose

QAMenu can be described as reduced data driven layout renderer. So why not generalize the renderer or use an existing third-party framework?

UI is particularly hard to reuse. Generalizing the renderer in a useful way would require noticeable more code and would likely still not satisfy many needs. The hypothesis is that it's more beneficial to compose apps of multiple specialized pieces instead of all-in-one solutions.

Without the need to satisfy e.g. changing the style of UI elements, QAMenu can provide way more targeted solutions with less code and less need for maintenance.