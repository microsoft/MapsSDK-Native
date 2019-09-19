import UIKit
import MicrosoftMaps

class ViewController: UIViewController, UIPickerViewDelegate {

    let CREDENTIALS_KEY = Bundle.main.infoDictionary?["CREDENTIALS_KEY"] as! String
    let LOCATION_LAKE_WASHINGTON = MSGeolocation(latitude: 47.609466, longitude: -122.265185)

    var pinLayer: MSMapElementLayer!
    var pinImage: MSMapImage!
    var geocodeController: GeocodeAlertController!
    let errorMessageController = UIAlertController(title:"", message:"", preferredStyle: .alert)

    @IBOutlet weak var mapView: MSMapView!
    @IBOutlet weak var demoMenu: UIView!
    @IBOutlet weak var addOnTapSwitch: UISwitch!

    @IBAction func hideOrShowDemoMenu(_ sender: Any) {
        demoMenu.isHidden = !demoMenu.isHidden
    }

    @IBAction func addMapIconsBySearch(_ sender: Any) {
        self.present(geocodeController, animated: true, completion: nil)
    }

    @IBAction func clearMapIcons(_ sender: Any) {
        pinLayer.elements.clear()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        mapView.credentialsKey = CREDENTIALS_KEY
        let scene = MSMapScene(location: LOCATION_LAKE_WASHINGTON, zoomLevel: 10 )
        self.mapView.setScene(scene, with: .none)
        pinLayer = MSMapElementLayer()
        mapView.layers.add(pinLayer)

        MSMapServices.setCredentialsKey(CREDENTIALS_KEY)

        let svgImagePath = Bundle.main.path(forResource: "mappin", ofType:"svg")
        do {
            let svgData = try Data(contentsOf: URL(fileURLWithPath: svgImagePath!))
            pinImage = MSMapImage(svgImage: svgData)
        } catch {}

        mapView.addUserDidTapHandler{ (point:CGPoint, location:MSGeolocation?) -> Bool in
            DispatchQueue.main.sync{
                guard self.addOnTapSwitch.isOn else {
                    return false
                }

                MSMapLocationFinder.findLocations(at: location!, with: nil, handleResultWith: { (result: MSMapLocationFinderResult) in
                    switch result.status {
                    case MSMapLocationFinderStatus.success:
                        if result.locations.isEmpty {
                            self.showMessage("No search result found")
                            return
                        }
                        let pushpin = MSMapIcon()
                        pushpin.location = MSGeolocation(
                            latitude: location!.latitude,
                            longitude: location!.longitude)
                        pushpin.title = result.locations[0].address.formattedAddress
                        if self.pinImage != nil {
                            pushpin.image = self.pinImage
                            pushpin.normalizedAnchorPoint = CGPoint(x: 0.5, y: 1)
                        }
                        self.pinLayer.elements.add(pushpin)
                    default:
                        self.showMessage("Error processing the request")
                    }
                })

                return true
            }
        }

        setupDemoMenu()
    }

    func setupDemoMenu() {
        geocodeController = UIStoryboard(name: "GeocodeAlert", bundle: nil).instantiateViewController(withIdentifier: "GeocodeAlert") as? GeocodeAlertController
        geocodeController.providesPresentationContextTransitionStyle = true
        geocodeController.definesPresentationContext = true
        geocodeController.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        geocodeController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        geocodeController.delegate = self

        errorMessageController.addAction(UIAlertAction(title:"OK", style:.default))
    }

    func showMessage(_ message: String) {
        self.errorMessageController.message = message
        self.present(self.errorMessageController, animated:true)
    }
}

extension ViewController: GeocodeAlertDelegate {

    func searchButtonTapped(query: String, culture: String, region: String, useLocation: Bool, useBoundingBox: Bool) {
        guard !query.isEmpty else {
            return
        }

        var referenceLocation: MSGeolocation?
        if useLocation {
            referenceLocation = self.mapView.mapCenter
        }
        var referenceBoundingBox: MSGeoboundingBox?
        if useBoundingBox {
            referenceBoundingBox = self.mapView.mapBounds
        }

        let options = MSMapLocationOptions()
        if !culture.isEmpty {
            options.setCulture(culture)
        }
        if !region.isEmpty {
            options.setRegion(region)
        }

        MSMapLocationFinder.findLocations(query, withReferencePoint: referenceLocation, withReferenceBoundingBox: referenceBoundingBox, with: options, handleResultWith: { (result: MSMapLocationFinderResult) in
            switch result.status {
            case MSMapLocationFinderStatus.success:
                self.pinLayer.elements.clear()
                let locations = NSMutableArray()

                for mapLocation in result.locations {
                    let pushpin = MSMapIcon()
                    pushpin.location = MSGeolocation(
                        latitude: mapLocation.point.latitude,
                        longitude: mapLocation.point.longitude,
                        altitude: 0,
                        altitudeReferenceSystem: MSMapAltitudeReferenceSystem.terrain)
                    pushpin.title = mapLocation.displayName
                    if self.pinImage != nil {
                        pushpin.image = self.pinImage
                        pushpin.normalizedAnchorPoint = CGPoint(x: 0.5, y: 1)
                    }
                    self.pinLayer.elements.add(pushpin)

                    locations.add(mapLocation.point)
                }
                if (locations.count > 1) {
                    self.mapView.setScene(MSMapScene(locations: locations as! [MSGeolocation]), with: MSMapAnimationKind.default)
                } else {
                    self.mapView.setScene(MSMapScene(location: locations[0] as! MSGeolocation), with: MSMapAnimationKind.default)
                }
            case MSMapLocationFinderStatus.emptyResponse:
                self.showMessage("No result was found")
            default:
                self.showMessage("Error processing the request")
            }
        })
    }
}
