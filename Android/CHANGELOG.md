# Bing Maps SDK for Android

Version 1.2.0 - February 2021
=============================
## Improvements
- Adds support for photoreal 3D cities.
- Adds support for route lines and custom route segments.
- Adds support for view padding and support for near/full visible region.
- Adds user location features.
- Adds traffic incidents.
- Adds vector images support through map style sheets.
- Adds a new flyout tapped event.
- Adds a picker that allows users to select a map style.
- Improves the experience when the map first loads or reloads.
- Updates the look and feel of the toolbar buttons and adds support for individual button alignment.
## Resolved Issues
- Fixes a few memory leaks of Java objects.
- Fixes a few map flashes that can occur during start.
- Fixes a temporary problem where the map stays partially loaded after a clean install.
- Fixes intermittent crashes by properly canceling some outstanding operations.
- Fixes an intermittent crash when the map is removed of the UI tree.
- Fixes black map case reported when the parent activity never goes fully out of view.
- Fixes miscellaneous issues causing the map to return map icons in the wrong order upon a hit test.
- Fixes display of map icons in raster map render mode.
- Fixes keyboard navigation for accessible elements.
## Breaking changes
- Adds nullability annotations to the SDK. Enables `@Nonnull` by default on parameters and methods that are not explicitly annotated, on a per-package basis.
- Updates firing tapped events order, from map tapped -> layer tapped to layer tapped -> base-layer tapped -> map tapped.
- Changes `MapLocationFinder`'s methods to return a [Future](https://developer.android.com/reference/java/util/concurrent/Future) object that can be used to work with the asynchronous operation including canceling the operation.
- New dependency on androidx. Note that there might be some work to migrate the client app if not using this already.
  - https://developer.android.com/jetpack/androidx
  - https://developer.android.com/jetpack/androidx/migrate

Version 1.1.4 - May 2020
========================
## Resolved Issues
- Fixes intermittent crashes observed on some devices.
- Fixes some cases where Japanese and Chinese glyphs were not rendered.
- Fixes some accessibility issues reported by users.

Version 1.1.3 - April 2020
==========================
## Improvements
- Adds support for Chinese languages.
- Improves accessibility support for TalkBack.
## Resolved Issues
- Fixes various Strict Mode violations.

Version 1.1.2 - March 2020
==========================
## Improvements
- Improves query validation in `MapLocationFinder`.
## Resolved Issues
- Fixes a missing tiles issue when the map transitions from Globe to web Mercator projection.
- Fixes an intermittent crash reported on some devices after map disposal.

Version 1.1.1 - March 2020
==========================
## Resolved Issues
- Fixes an intermittent crash due to a race condition when the map loads.
- Fixes an issue causing a map icon to disappear sometimes when moved to a different layer.

Version 1.1.0 - March 2020
==========================
## Improvements
- Adds support for additional markets, like Japan and Korea.
- Adds language fallback support.
- Adds 64-bit emulator support.
## Resolved Issues
- Fixes scene changed events so that callbacks are always invoked on the UI thread.
- Fixes an issue causing heading and pitch to be slightly off in some scenes.
## Breaking changes
- Changes `MapView`'s properties `MapSize` and `ViewPadding` to use device-independent pixels.
- Changes `MapView`'s panning methods to use device-independent pixels. The change affects the following methods:
  - `pan`
  - `beginPan`
  - `startContinuousPan`
  - `beginStartContinuousPan`
- Renames `OnMapLoadingStatusChangedListener`'s callback method `onMapLoadingStatusChanging` to `onMapLoadingStatusChanged`.
- Renames `MapFlyout.CustomViewAdapter`'s method `getView` to `getFlyoutView`.

Version 1.0.3 - January 2020
============================
## Improvements
- Adds support for scene of locations with a desired maximum zoom level of detail.
- Adds support for scene of locations with a desired minimum amount of space to display around the center.
## Resolved Issues
- Fixes level of detail when setting a scene of location and zoom level.
- Fixes an issue with landmarks vanishing when style is reloaded.
- Fixes an issue with map element tapped event not firing sometimes.

Version 1.0.2 - December 2019
=============================
## Improvements
- Improves the experience when the map resumes.
## Resolved Issues
- Fixes a crash when setting a scene of locations.
- Fixes position issues of flyout relative to its parent map icon.
- Fixes an issue with compass rotation.

Version 1.0.1 - November 2019
=============================
## Improvements
- Improves map toolbar's appearance and support for dark and light modes.
- Adds new shape `Geocircle`.
- Adds support for custom anchor point on flyout.
- Adds support for custom styling properties on map elements.
- Adds support for polygons of various shapes.
- Adds support for view padding.
- Adds support to zoom to a desired level of detail.
- Reduces flashing of map icons when the view changes.
## Resolved Issues
- Fixes management of resources upon suspend and resume.
- Fixes a crash when `GroundOverlayMapLayer` is used.
- Fixes other intermittent crashes.

Version 1.0.0 - September 2019
==============================
## Breaking changes
- Updates various public classes.
- Introduces `Geoshape` and `Geoposition` classes, and refactors all `Geo` classes accordingly.
- Renames `Geolocation` to `Geopoint`.
- Renames several `MapView`'s methods and properties, including lifecycle related handlers.
- Renames various listeners and ensures callbacks are invoked on the UI thread.
- Removes icon drag related methods and interfaces.
- Renames several `MapFlyout`'s methods and properties.
- Renames several `MapUserInterfaceOptions`'s properties.
- Renames a few `Search` types and listeners.
- Moves all `Search` enums into their own files.

For more details see the full list of [Breaking API changes in version 1.0](https://docs.microsoft.com/en-us/bingmaps/sdk-native/v1-breaking-changes/).

## Improvements
- Improves load time by over 30%.
- Includes optimizations for vector map render mode.
- Adds `Geopoint` convenience constructor for `android.location.Location`.
- Adds support for complex polygons.
- Adds support for custom flyout views.
- Adds support for language and region settings in Map Services.
## Resolved Issues
- Fixes a crash when `MapView` is declared in XML layout file.
- Fixes a crash when attempting to override settings in `MapServices`.
- Fixes a race condition that prevented map content from loading.
- Fixes polyline default color and custom stroke width.
- Fixes black map after suspend and resume.
- Fixes rendering artifacts after suspend and resume.
- Fixes lint warnings.

Version 0.2.0 - July 2019
=========================
## Breaking changes
- Renames `MapIcon`'s method `getFlyoutShown` to `getIsFlyoutVisible` and adds `setIsFlyoutVisible`.
- Renames several `MapCamera` related classes.
- Renames `MapView`'s method `doesViewContainLocation` to `isLocationInView`.
## Improvements
- Adds support for ARM64.
- Adds new event `MapElementLayer.MapElementTapped`.
- Adds support to report native crashes as minidump.
## Resolved Issues
- Fixes `MapFlyout.PlacementOffset` property not working as expected.

Version 0.1.4 - June 2019
=========================
## Resolved Issues
- Fixes a crash on map dispose.
- Fixes continuous rotate, tilt, and zoom not working.

Version 0.1.3 - June 2019
=========================
## Improvements
- Improves pan gesture.
## Resolved Issues
- Fixes unexpected map movements after rotation and stretch & pinch gestures.

Version 0.1.2 - May 2019
========================
## Improvements
- Improves default set scene animations.
- Includes optimizations for raster map render mode.
## Resolved Issues
- Fixes a few race conditions.
- Fixes incorrect status code for reverse geocoding.
- Fixes a styling issue in raster map render mode.

Version 0.1.1 - May 2019
========================
## Resolved Issues
- Fixes a crash in Map Services.

Version 0.1.0 - May 2019
========================
Initial release of the Bing Maps SDK for Android (developer preview).

Features a native map control and an accompanying map services API set.
The map control is powered by a full vector 3D map engine with a number of
standard mapping capabilities, including displaying icons, drawing polylines
and polygons, and overlaying texture sources.
