# Bing Maps SDK for Android

Version 0.2.0 - July 2019
=========================
## Breaking changes
- Renames MapIcon API method getFlyoutShown() to getIsFlyoutVisible() and adds setIsFlyoutVisible()
- Renames several MapCamera related classes
- Renames method doesViewContainLocation to isLocationInView
## Improvements
- Adds support for ARM64 
- Adds new event MapElementLayer.MapElementTapped
- Adds support to report native crashes as minidump
## Resolved Issues
- Fixes MapFlyout property PlacementOffset doesn't work as expected

Version 0.1.4 - June 2019
=========================
## Resolved Issues
- Fixes a crash on map dispose.
- Fixes start continuous rotate, tilt, and zoom not working.

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
Initial release of the Bing Maps SDK for Android (developer preview)

Features a native map control and an accompanying map services API set.
The map control is powered by a full vector 3D map engine with a number of
standard mapping capabilities, including displaying icons, drawing polylines
and polygons, and overlaying texture sources.
