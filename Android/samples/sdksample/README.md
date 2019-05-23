# Bing Maps Sample Android App

This tutorial goes through creating an Android app with a Bing Maps Native Control step-by-step.

## Prerequisites

1. **Bing Maps Key.** Must be obtained to use the Bing Maps SDK. The Bing Maps Key will need to be set through the API in order to use the Bing Maps native control and to make API requests to Bing Maps services. Visit the [Bing Maps Dev Center Help page](https://docs.microsoft.com/bingmaps/getting-started/bing-maps-dev-center-help/getting-a-bing-maps-key) for detailed steps on obtaining one.
2. **Android Studio.** This example is built using Android Studio. You can download it [here](https://developer.android.com/studio/#downloads).

## Running the sample app

* Open the SDK Sample in Android Studio and enter your Bing Maps Key as follow.
In the `app` folder, create a file named `secrets.gradle` and put there your Bing Maps key like shown:

>```
> ext.credentialsKey = "ENTER YOUR KEY HERE"
>```

Ready to run!

## Creating a new project

* After Android Studio is installed, create a new project in it.

    Select **Phone and Tablet** tab and choose **Empty Activity**, press Next.

* Choose a name, package and location for your project.

    When it comes to language, this tutorial is in **Java**, though feel free to use Kotlin if that's your preference.

    Set **API 16** as your Minimum API level.

    Press **Finish** when you're ready.

## Including Bing Maps Native Control in your project

In your project's `app` folder, create a file named `secrets.gradle` and put there your Bing Maps key like shown:

>```
> ext.credentialsKey = "ENTER YOUR KEY HERE"
>```

In your `app/build.gradle` file, apply this line at the top to import the external variables from newly created file:

>```
> apply from: 'secrets.gradle'
>```

Next, in the same file, inside `buildTypes` block, insert following block next to `release` block to add a build config field with your Bing Maps key in order to be able to use it from Java code:

>```
> buildTypes.each {
>     it.buildConfigField "String", "CREDENTIALS_KEY", "\"$credentialsKey\""
> }
>```

Then, before `dependencies` block, insert following snippet at top level to add our Maven repo:

>```
> repositories {
>     maven {
>         url  "https://microsoft-maps.bintray.com/Maven"
>     }
> }
>```

And finally, inside `dependencies` block, add the following line:

>```
> implementation 'com.microsoft.maps:maps-sdk:0.1.2'
>```

## Adding a map view to your activity

Add following markup to your activity layout (`app/res/layout/{your_layout_file}.xml`). This will be the map view:

>```xml
> <FrameLayout
>     android:id="@+id/map_view"
>     android:layout_width="match_parent"
>     android:layout_height="match_parent"
>     />
>```

Add these imports to your source file:

>```java
> import com.microsoft.maps.MapRenderMode;
> import com.microsoft.maps.MapView;
>```

At the top of your activity class, declare a MapView:

>```java
> private MapView mMapView;
>```

Place following code in your activity's `onCreate` method, after `setContentView` call, to initialize the map view:

>```java
> mMapView = new MapView(this, MapRenderMode.VECTOR);  // or use MapRenderMode.RASTER for 2D map
> mMapView.setCredentialsKey(BuildConfig.CREDENTIALS_KEY);
> ((FrameLayout)findViewById(R.id.map_view)).addView(mMapView);
>```

Override `onResume` and `onPause` with calls to map view's `resume` and `suspend`:

>```java
> @Override
> protected void onResume() {
>     super.onResume();
>     mMapView.resume();
> }
>
> @Override
> protected void onPause() {
>     super.onPause();
>     mMapView.suspend();
> }
>```

Ready to run!

## Further customizations

### Scenes

Let's go through a common scenario to set map scene to a specific location on startup.

First, add following imports:

>```java
> import com.microsoft.maps.Geolocation;
> import com.microsoft.maps.MapAnimationKind;
> import com.microsoft.maps.MapScene;
>```

Next step is declaring the location. Say, we want to show Seattle and Bellevue and choose Lake Washington in between:

>```java
> private static final Geolocation LAKE_WASHINGTON = new Geolocation(47.609466, -122.265185);
>```

Then override your activity's `onStart` method with a `setScene` call:

>```java
> @Override
> protected void onStart() {
>     super.onStart();
>     mMapView.setScene(
>         MapScene.createFromLocationAndZoomLevel(LAKE_WASHINGTON, 10),
>         MapAnimationKind.NONE);
> }
>```

### Pins

You can attach pins to locations on the map using custom element layer populated with `MapImage` elements. Here's an example:

First, you'll need these imports:

>```java
> import com.microsoft.maps.Geolocation;
> import com.microsoft.maps.MapElementLayer;
> import com.microsoft.maps.MapIcon;
> import com.microsoft.maps.MapImage;
>```

Then, declare the element layer as class member:

>```java
> private MapElementLayer mPinLayer;
>```

Next step, initialize and add it to map view's layers in your `onCreate` method:

>```java
> mPinLayer = new MapElementLayer();
> mMapView.getLayers().add(mPinLayer);
>```

Use the following snippet to add pins:

>```java
> Geolocation location = ...  // your pin lat-long coordinates
> String title = ...          // title to be shown next to the pin
> Bitmap pinBitmap = ...      // your pin graphic
>
> MapIcon pushpin = new MapIcon();
> pushpin.setLocation(location);
> pushpin.setTitle(title);
> pushpin.setImage(new MapImage(pinBitmap));
>
> mPinLayer.getElements().add(pushpin);
>```

***Note**: if pins in your scenario use the same graphic, it is recommended to reuse the associated `MapImage` object. Rather than creating a new one for each pin, consider declaring and initializing it similarly to your `MapElementLayer` instance.*

To clear existing pins, just call `clear()` on `Elements` member of the associated layer:

>```java
> mPinLayer.getElements().clear();
>```

### Styling

There's a set of predefined styles exposed by MapStyleSheets class:
* `roadLight`: symbolic map, light color scheme. Default look.
* `roadDark`: symbolic map, dark color scheme.
* `roadCanvasLight`: symbolic map, light low-contrast color scheme.
* `roadHighContrastLight`: symbolic map, light high-contrast color scheme.
* `roadHighContrastDark`: symbolic map, dark high-contrast color scheme.
* `aerial`: photorealistic map.
* `aerialWithOverlay`: hybrid map, photorealistic tiles with symbolic entities rendered on top.

Example setting `aerialWithOverlay` map style:

>```java
> import com.microsoft.maps.MapStyleSheets;
>
> ...
>
> mMapView.setMapStyleSheet(MapStyleSheets.aerialWithOverlay());
>```

Bing Maps Native Control also supports custom styling via JSON, using the same format as desktop and iOS controls. Here's an example applying your own style:

>```java
> import com.microsoft.maps.MapStyleSheet;
> import com.microsoft.maps.Optional;
>
> ...
>
> Optional<MapStyleSheet> style = MapStyleSheet.fromJson(yourCustomStyleJsonString);
> if (style.isPresent()) {
>     mMapView.setMapStyleSheet(style.get());
> } else {
>     // Custom style JSON is invalid
> }
>```

### Map projection

Bing Maps Native Control runs on a 3D engine and it supports switching map projection between Web Mercator and Globe on demand and in real time. Here's an example:

>```java
> import com.microsoft.maps.MapProjection;
>
> ...
>
> mMapView.setMapProjection(MapProjection.GLOBE);
> mMapView.setMapProjection(MapProjection.WEB_MERCATOR);
>```
