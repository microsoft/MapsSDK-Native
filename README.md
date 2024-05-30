> [!WARNING]
> **Bing Maps for Enterprise is deprecated and will be retired**
> * Enterprise account customers can continue to use Bing Maps for Enterprise services **until June 30th, 2028**.
> * Free (Basic) account customers can continue to use Bing Maps for Enterprise services until **June 30th, 2025**.
> * To avoid service disruptions, all implementations using Bing Maps for Enterprise REST APIs and SDKs will need to be updated to use [Azure Maps](https://azuremaps.com) by the retirement date that applies to your Bing Maps for Enterprise account type.
> * For migration documentation, please see [Bing Maps Migration Overview](https://learn.microsoft.com/azure/azure-maps/migrate-bing-maps-overview).
> * For more details on the retirement, see the [announcement](https://aka.ms/BMERetirementAnnouncement) on the Bing Maps Blog.

![Bing Maps Logo](https://github.com/Microsoft/Bing-Maps-V8-TypeScript-Definitions/blob/master/images/BingMapsLogoTeal.png)

<img src="https://github.com/Microsoft/MapsSDK-Native/wiki/Content/Banner.png">

Welcome to the Bing Maps SDK for Android and iOS!

> Feature requests and bug reports are very much welcome at the [issues page](https://github.com/Microsoft/MapsSDK-Native/issues).
Your insights and scenarios are critically important to us.


# Overview
The **Bing Maps SDK for Android** and **Bing Maps SDK for iOS** are libraries for building mapping applications for Android and iOS.
The SDKs feature a native map control and an accompanying map services API set.

The map control is powered by a full vector 3D map engine with [a number of standard mapping capabilities](https://github.com/Microsoft/MapsSDK-Native/wiki/Concepts_Table)
including displaying icons, drawing polylines and polygons, and overlaying texture sources.  This engine brings in the same 3D Native
support you know from our [XAML Map Control](https://msdn.microsoft.com/windows/uwp/maps-and-location/index) in Windows 10, including
worldwide 3D elevation data (via our Digital Elevation Model).

The native controls and map services API set will continue to mature and stabilize in future SDK releases!

| <img src="https://github.com/Microsoft/MapsSDK-Native/wiki/Content/Road.png"> | <img src="https://github.com/Microsoft/MapsSDK-Native/wiki/Content/Globe.png"> | <img src="https://github.com/Microsoft/MapsSDK-Native/wiki/Content/Aerial.png"> |
| :--- | :--- | :--- |

# Getting started

For instructions to download and setup the sample apps, check out the
[Getting Started](https://github.com/Microsoft/MapsSDK-Native/wiki/Getting_Started) page on the wiki.
* [Sample Android App](Android/samples/sdksample)
* [Sample iOS App](iOS/samples/sdksample)

The wiki also contains documentation, links to the API reference, and an in-depth overview of a few common scenarios showcased in the
sample app for Android and iOS.

# What is in this repo?

This repository includes **samples**, **documentation** and **release history**.

The core source code for the native controls is not part of this repository.
* The Bing Maps SDK for Android is available [here](https://docs.microsoft.com/bingmaps/sdk-native).
* The Bing Maps SDK for iOS is available [here](https://docs.microsoft.com/bingmaps/sdk-native).

The Bing Maps SDK for Android and Bing Maps SDK for iOS are licensed under [Microsoft Bing Map Platform APIs Terms of Use](https://www.microsoft.com/maps/product/terms.html).

# Contributing

Contributions to the documentation and supporting samples are welcome. Please refer to the [Contribution Process](CONTRIBUTING.md) for more details.

# Data Collection / Telemetry
This project collects usage data and sends it to Microsoft to help improve our products and services. Read our [Privacy Notice](PRIVACY)
to learn more. Telemetry is disabled in the Bing Maps SDK for Android and Bing Maps SDK for iOS by default, and can be enabled with the API.

# Code of Conduct
This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
