import UIKit
import MicrosoftMaps

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

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
    var currentStyle: MapStyle!
    let searchStringController = UIAlertController(title:"", message:"Enter a search string", preferredStyle:.alert)
    let errorMessageController = UIAlertController(title:"", message:"", preferredStyle: .alert)
    let jsonInputController = UIAlertController(title:"", message:"Enter style JSON", preferredStyle: .alert)

    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var mapView: MSMapView!
    @IBOutlet weak var demoButton: UIButton!
    @IBOutlet weak var demoMenu: UIView!
    @IBOutlet weak var mapStylesPickerView: UIPickerView!
    @IBOutlet weak var projectionSeg: UISegmentedControl!
    @IBOutlet weak var addOnTapSwitch: UISwitch!

    @IBAction func hideOrShowDemoMenu(_ sender: Any) {
        demoMenu.isHidden = !demoMenu.isHidden
        self.setNeedsStatusBarAppearanceUpdate()
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

        currentStyle = self.traitCollection.userInterfaceStyle == .light ? MapStyle.roadLight : MapStyle.roadDark
        updateMapStyle()
        updateStylePicker()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return currentStyle.colorScheme == .dark ? .lightContent : .darkContent
        } else {
            return .default
        }
    }

    func updateMapStyle() {
        mapView.setStyleSheet(currentStyle.styleSheet)
        if #available(iOS 13.0, *) {
            parentView.overrideUserInterfaceStyle = currentStyle.colorScheme
        }
        self.setNeedsStatusBarAppearanceUpdate()
    }

    func setupDemoMenu() {
        searchStringController.addTextField {(textField) in
            textField.text = ""
        }
        searchStringController.addAction(UIAlertAction(title: "Search", style:.default, handler:{_ in
            let searchKeyword = self.searchStringController.textFields![0].text
            self.searchStringController.textFields![0].text = ""
            // do local search with the specified keyword
            LocalSearch.sendRequest(queryOptional: searchKeyword, bounds: self.mapView.mapBounds, _completion: {(results) in
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
            self.searchStringController.textFields![0].text = ""
        }))

        errorMessageController.addAction(UIAlertAction(title:"OK", style:.default))

        jsonInputController.addTextField {(textField) in
            textField.text = self.customMapStyleString
        }
        jsonInputController.addAction(UIAlertAction(title: "Set", style:.default, handler:{_ in
            let customMapStyleString = self.jsonInputController.textFields![0].text

            // Reset the text to default custom JSON.
            self.jsonInputController.textFields![0].text = self.customMapStyleString

            var styleSheetFromJson:MSMapStyleSheet? = nil
            if (customMapStyleString != nil && MSMapStyleSheet.try(toParseJson: customMapStyleString!, into:&styleSheetFromJson)) {
                self.currentStyle = MapStyle(name: "Custom", styleSheet: styleSheetFromJson!, colorScheme: .unspecified)
                self.updateMapStyle()
            } else {
                self.errorMessageController.message = "Custom style JSON is invalid"
                self.present(self.errorMessageController, animated:true)
            }
        }))
        jsonInputController.addAction(UIAlertAction(title:"Cancel", style:.default, handler:{_ in
            // Reset the text to default custom JSON.
            self.jsonInputController.textFields![0].text = self.customMapStyleString

            self.updateStylePicker()
        }))

        mapStylesPickerView.delegate = self
        mapStylesPickerView.dataSource = self
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (row >= MapStyle.all.count) {
            // custom map style
            self.present(self.jsonInputController, animated:true)
        }
        else {
            currentStyle = MapStyle.all[row]
            updateMapStyle()
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return MapStyle.all.count + 1
    }

    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return row < MapStyle.all.count ? MapStyle.all[row].name : "Custom"
    }

    func updateStylePicker() {
        let oldIndex = MapStyle.all.firstIndex { (style: MapStyle) -> Bool in
            style.name == currentStyle.name
        }!
        mapStylesPickerView.selectRow(oldIndex, inComponent: 0, animated: true)
    }
}
