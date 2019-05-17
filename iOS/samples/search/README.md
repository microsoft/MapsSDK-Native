# Bing Maps Search Sample for iOS

This tutorial goes through using map services (particularly, geocoding) in an iOS app with Bing Maps Native SDK.  
**For prerequisites and project setup refer to the primary sample "`sdksample`".**

## Using map services in your app

Before making any API requests, you need to provide your Bing Maps key in advance.

In this doc we assume you import `MicrosoftMaps` in your source file. Then, in a place before any map services call is made (such as your controller's `viewDidLoad` method), provide your credentials.

>```swift
> MSMapServices.setCredentialsKey("your bing maps key");
>```

All set!

## Performing requests

### Geocoding

For geocoding requests, use `MSMapLocationFinder` class.

Say, we want to geocode Bellevue, Washington. Since there's multiple Bellevues, let's provide a reference point that we know is in Bellevue. Since we're interested in the first result, let's also ask the service to only return one.

>```swift
> let referencePoint = MSGeolocation(latitude: 47.612498, longitude: -122.204200)
>
> let options = MSMapLocationOptions()
> options.setMaxResults(1)
>
> MSMapLocationFinder.findLocations("Bellevue", withReferencePoint: referencePoint, with: options, handleResultWith: {
>     (result: MSMapLocationFinderResult) in
>         if (result.status == MSMapLocationFinderStatus.success) {
>             let bellevue = result.locations[0]
>             ...
>         }
> })
>```

If status code is `SUCCESS`, the response is guaranteed to contain at least one location.

But what if we're not sure that our reference point is correct? Let's reverse geocode it!

>```swift
> MSMapLocationFinder.findLocations(at: referencePoint, with: nil, handleResultWith: {
>     (result: MSMapLocationFinderResult) in
>         if (result.status == MSMapLocationFinderStatus.success) {
>             if (result.locations[0].address.locality == "Bellevue") {
>                 print("Yay!")
>             }
>         }
> })
>```
