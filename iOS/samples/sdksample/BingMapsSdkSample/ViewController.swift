import UIKit
import MicrosoftMaps

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var mapStyleStrings = ["RoadLight", "RoadDark", "RoadCanvasLight", "Aerial", "AerialWithOverlay", "RoadHightContrastLight", "RoadHighContrastDark", "Custom"]
    var mapStyles = [MSMapStyleSheets.roadLight(), MSMapStyleSheets.roadDark(), MSMapStyleSheets.roadCanvasLight(), MSMapStyleSheets.aerial(), MSMapStyleSheets.aerialWithOverlay(), MSMapStyleSheets.roadHighContrastLight(), MSMapStyleSheets.roadHighContrastDark()]

    let LOCATION_LAKE_WASHINGTON = MSGeopoint(latitude: 47.609466, longitude: -122.265185)
    let customMapStyleString = """
        {
            "version": "1.0",
            "settings": {
                "landColor": "#FFFFFF",
                "spaceColor": "#000000"
            },
            "elements": {
                "mapElement": {
                    "labelColor": "#000000",
                    "labelOutlineColor": "#FFFFFF"
                },
                "water": {
                    "fillColor": "#DDDDDD"
                },
                "area": {
                    "fillColor": "#EEEEEE"
                },
                "political": {
                    "borderStrokeColor": "#CCCCCC",
                    "borderOutlineColor": "#00000000"
                }
            }
        }
    """

    var pinLayer:MSMapElementLayer!
    var pinImage:MSMapImage!
    let searchStringController = UIAlertController(title:"", message:"Enter a search string", preferredStyle:.alert)
    let errorMessageController = UIAlertController(title:"", message:"", preferredStyle: .alert)
    let jsonInputController = UIAlertController(title:"", message:"Enter style JSON", preferredStyle: .alert)

    @IBOutlet weak var mapView: MSMapView!
    @IBOutlet weak var demoButton: UIButton!
    @IBOutlet weak var demoMenu: UIView!
    @IBOutlet weak var mapStylesPickerView: UIPickerView!
    @IBOutlet weak var projectionSeg: UISegmentedControl!
    @IBOutlet weak var addOnTapSwitch: UISwitch!

    @IBAction func hideOrShowDemoMenu(_ sender: Any) {
        demoMenu.isHidden = !demoMenu.isHidden
    }

    @IBAction func onProjectChanged(_ sender: Any)
    {
        switch projectionSeg.selectedSegmentIndex
        {
        case 0:
            mapView.projection = MSMapProjection.mercator
        case 1:
            mapView.projection = MSMapProjection.globe
        default:
            break
        }
    }

    @IBAction func addMapIconsBySearch(_ sender: Any) {
        self.present(searchStringController, animated:true)
    }

    @IBAction func clearMapIcons(_ sender: Any) {
        pinLayer.elements.clear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Make demo button round.
        demoButton.layer.cornerRadius = demoButton.frame.size.width / 2.0;

        // Do any additional setup after loading the view, typically from a nib.
        mapView.credentialsKey = Bundle.main.infoDictionary?["CREDENTIALS_KEY"] as! String

        updateMapViewColorScheme()

        let scene = MSMapScene(location: LOCATION_LAKE_WASHINGTON, zoomLevel: 10 )
        self.mapView.setScene(scene, with: .none)

        pinLayer = MSMapElementLayer()
        mapView.layers.add(pinLayer)

        let svgImagePath = Bundle.main.path(forResource: "mappin", ofType:"svg")
        do {
            let svgData = try Data(contentsOf: URL(fileURLWithPath: svgImagePath!))
            pinImage = MSMapImage(svgImage: svgData)
        } catch {
        }

        mapView.addUserDidTapHandler{ (point:CGPoint, location:MSGeopoint?) -> Bool in
            if self.addOnTapSwitch.isOn {
                let pushpin = MSMapIcon()
                pushpin.location = location!
                if self.pinImage != nil {
                    pushpin.image = self.pinImage
                    pushpin.normalizedAnchorPoint = CGPoint(x: 0.5, y: 1.0)
                }
                self.pinLayer.elements.add(pushpin)

                return true
            }
            return false
        }

        setupDemoMenu()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if (traitCollection.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle) {
            self.updateMapViewColorScheme()
        }
    }

    func updateMapViewColorScheme() {
        mapView.setStyleSheet(traitCollection.userInterfaceStyle == .dark ? MSMapStyleSheets.roadDark() : MSMapStyleSheets.roadLight())
    }

    func setupDemoMenu() {
        searchStringController.addTextField {(textField) in
            textField.text = ""
        }
        searchStringController.addAction(UIAlertAction(title: "Search", style:.default, handler:{_ in
            let searchKeyword = self.searchStringController.textFields![0].text
            // clear the text
            self.searchStringController.textFields![0].text = ""
            // do local search with the specified keyword
            LocalSearch.sendRequest(queryOptional: searchKeyword, bounds: self.mapView.mapBounds, _completion:  {(results) in
                if results == nil || results!.isEmpty {
                    self.errorMessageController.message = "No search result found"
                    self.present(self.errorMessageController, animated:true)
                }
                else {
                    for result in results! {
                        let pushpin = MSMapIcon()
                        pushpin.location = result.location
                        pushpin.title = result.name as String
                        if self.pinImage != nil {
                            pushpin.image = self.pinImage
                            pushpin.normalizedAnchorPoint = CGPoint(x: 0.5, y: 1.0)
                        }
                        self.pinLayer.elements.add(pushpin)
                    }
                }
            })
        }))
        searchStringController.addAction(UIAlertAction(title:"Cancel", style:.default, handler:{_ in
            // clear the text
            self.searchStringController.textFields![0].text = ""
        }))

        errorMessageController.addAction(UIAlertAction(title:"OK", style:.default))

        jsonInputController.addTextField {(textField) in
            textField.text = self.customMapStyleString
        }
        jsonInputController.addAction(UIAlertAction(title: "Set", style:.default, handler:{_ in
            let customMapStyleString = self.jsonInputController.textFields![0].text
            // resets the text
            self.jsonInputController.textFields![0].text = self.customMapStyleString
            // do local search with the specified keyword
            var styleSheetFromJson:MSMapStyleSheet? = nil
            if (customMapStyleString != nil && MSMapStyleSheet.try(toParseJson: customMapStyleString!, into:&styleSheetFromJson)) {
                self.mapView.setStyleSheet(styleSheetFromJson!)
            }
            else{
                self.errorMessageController.message = "Custom style JSON is invalid"
                self.present(self.errorMessageController, animated:true)
            }
        }))
        jsonInputController.addAction(UIAlertAction(title:"Cancel", style:.default, handler:{_ in
            // resets the text
            self.jsonInputController.textFields![0].text = self.customMapStyleString
        }))

        mapStylesPickerView.delegate = self
        mapStylesPickerView.dataSource = self
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row >= mapStyleStrings.count - 1) {
            // custom map style
            self.present(self.jsonInputController, animated:true)
        }
        else {
            self.mapView.setStyleSheet(mapStyles[row])
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mapStyleStrings.count
    }

    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mapStyleStrings[row]
    }
}
