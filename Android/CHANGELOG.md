# Bing Maps SDK for Android

Version 1.0.0 - September 2019
==============================
## Breaking changes
- Updates various public classes.
- Introduces `Geoshape` and `Geoposition` classes, and refactors all `Geo` classes accordingly.
- Renames `Geolocation` to `Geopoint`.
- Renames several `MapView` methods and properties, including lifecycle related handlers.
- Renames various listeners and ensures callbacks are invoked on the UI thread.
- Removes icon drag related methods and interfaces.
- Renames several `MapFlyout` methods and properties.
- Renames several `MapUserInterfaceOptions` properties.
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
- Renames `MapIcon` method `getFlyoutShown` to `getIsFlyoutVisible` and adds `setIsFlyoutVisible`.
- Renames several `MapCamera` related classes.
- Renames `MapView` method `doesViewContainLocation` to `isLocationInView`.
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
