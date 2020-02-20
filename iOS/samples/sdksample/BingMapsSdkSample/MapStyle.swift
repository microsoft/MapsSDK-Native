import Foundation
import MicrosoftMaps

class MapStyle {

    static let roadLight = MapStyle(
        name: "RoadLight",
        styleSheet: MSMapStyleSheets.roadLight(),
        colorScheme: .light)
    static let roadDark = MapStyle(
        name: "RoadDark",
        styleSheet: MSMapStyleSheets.roadDark(),
        colorScheme: .dark)
    static let roadCanvasLight = MapStyle(
        name: "RoadCanvasLight",
        styleSheet: MSMapStyleSheets.roadCanvasLight(),
        colorScheme: .light)
    static let aerial = MapStyle(
        name: "Aerial",
        styleSheet: MSMapStyleSheets.aerial(),
        colorScheme: .dark)
    static let aerialWithOverlay = MapStyle(
        name: "AerialWithOverlay",
        styleSheet: MSMapStyleSheets.aerialWithOverlay(),
        colorScheme: .dark)
    static let roadHighContrastLight = MapStyle(
        name: "RoadHighContrastLight",
        styleSheet: MSMapStyleSheets.roadHighContrastLight(),
        colorScheme: .light)
    static let roadHighContrastDark = MapStyle(
        name: "RoadHighContrastDark",
        styleSheet: MSMapStyleSheets.roadHighContrastDark(),
        colorScheme: .dark)

    static let all = [roadLight, roadDark, roadCanvasLight, aerial, aerialWithOverlay, roadHighContrastLight, roadHighContrastDark]

    var name: String
    var styleSheet: MSMapStyleSheet
    var colorScheme: UIUserInterfaceStyle

    init(name: String, styleSheet: MSMapStyleSheet, colorScheme: UIUserInterfaceStyle) {
        self.name = name
        self.styleSheet = styleSheet
        self.colorScheme = colorScheme
    }
}
