# Bing Maps Sample Android App

This tutorial goes through using map services (particularly, geocoding) in an Android app with Bing Maps Native SDK.  
**For prerequisites and project setup refer to the primary sample "`sdksample`".**

## Using MapServices in your app

Before making any API requests, you need to provide your Bing Maps key in advance.

First, add this import to your source file:

>```java
> import com.microsoft.maps.MapServices;
>```

Then, in a place before any map services call is made (such as your activity's `onCreate` method), provide your credentials.

>```java
> MapServices.setCredentialsKey(BuildConfig.CREDENTIALS_KEY);
>```

All set!

## Performing requests

### Geocoding

For geocoding requests, use `MapLocationFinder` class.

You will need following imports for this example:

>```java
> import com.microsoft.maps.search.MapLocation;
> import com.microsoft.maps.search.MapLocationFinder;
> import com.microsoft.maps.search.MapLocationFinderResult;
> import com.microsoft.maps.search.MapLocationFinderStatus;
> import com.microsoft.maps.search.MapLocationOptions;
>```

Say, we want to geocode Bellevue, Washington. Since there's multiple Bellevues, let's provide a reference point that we know is in Bellevue. Since we're interested in the first result, let's also ask the service to only return one.

>```java
> Geopoint referencePoint = new Geopoint(47.612498, -122.204200);
> MapLocationOptions options = new MapLocationOptions().setMaxResults(1);
> MapLocationFinder.findLocations("Bellevue", referencePoint, options, new MapLocationCallback() {
>     @Override
>     public void onResult(MapLocationFinderResult result) {
>         if (result.getStatus() == MapLocationFinderStatus.SUCCESS) {
>             MapLocation bellevue = result.getLocations().get(0);
>             ...
>         }
>     }
> });
>```

If status code is `SUCCESS`, the response is guaranteed to contain at least one location.

But what if we're not sure that our reference point is correct? Let's reverse geocode it!

>```java
> MapLocationFinder.findLocationsAt(referencePoint, null, new OnMapLocationFinderResultListener() {
>     @Override
>     public void onMapLocationFinderResult(MapLocationFinderResult result) {
>         if (result.getStatus() == MapLocationFinderStatus.SUCCESS) {
>             if (result.getLocations().get(0).getAddress().getLocality().equals("Bellevue")) {
>                 // Yay!
>             }
>         }
>     }
> });
>```
