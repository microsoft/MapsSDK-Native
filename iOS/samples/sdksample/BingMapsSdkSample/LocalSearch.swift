import UIKit
import MicrosoftMaps

class LocalSearch: NSObject {
    static let CREDENTIALS_KEY = Bundle.main.infoDictionary?["CREDENTIALS_KEY"] as! String
    static let URL_ENDPOINT = "https://dev.virtualearth.net/REST/v1/LocalSearch/"
    + "?query={query}"
    + "&userMapView={south},{west},{north},{east}"
    + "&key=" + CREDENTIALS_KEY

    struct Poi {
        var name: NSString!
        var location:MSGeopoint!
    }

    static func sendRequest(queryOptional:String?, bounds:MSGeoboundingBox, _completion: @escaping (Array<Poi>?) -> Void ) {
        guard let query = queryOptional else {
            _completion(nil)
            return
        }
        if (query == "") {
            _completion(nil)
            return
        }
        var urlString = URL_ENDPOINT.replacingOccurrences(of: "{query}", with: query)
        urlString = urlString.replacingOccurrences(of: "{south}", with: String(bounds.south))
        urlString = urlString.replacingOccurrences(of: "{west}", with: String(bounds.west))
        urlString = urlString.replacingOccurrences(of: "{north}", with: String(bounds.north))
        urlString = urlString.replacingOccurrences(of: "{east}", with: String(bounds.east))

        guard let url = URL(string: urlString) else {
            _completion(nil)
            return
        }

        let request = URLRequest(url: url)
        let session = URLSession.shared

        session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            DispatchQueue.main.async {
                _completion(parse(data:data))
            }
        }).resume()
    }

    static func parse(data:Data?) -> (Array<Poi>) {
        var results = Array<Poi>()

        do {
            let responseJObj = try JSONSerialization.jsonObject(with:data!, options:[]) as? NSDictionary
            let resourceSetsJArr = responseJObj!["resourceSets"] as! NSArray

            if resourceSetsJArr.count > 0 {
                let resourceSetJObj = resourceSetsJArr[0] as? NSDictionary
                let resourcesJArr = resourceSetJObj!["resources"] as! NSArray

                for resourceObj in resourcesJArr {
                    let resourceObjDictionary = resourceObj as! NSDictionary
                    // some results do not contain point
                    if resourceObjDictionary["point"] != nil {
                        var poi = Poi()
                        poi.name = resourceObjDictionary["name"] as? NSString
                        let pointJObj = resourceObjDictionary["point"] as! NSDictionary
                        let coordinatesJArr = pointJObj["coordinates"] as! NSArray
                        poi.location = MSGeopoint(latitude:coordinatesJArr[0] as! Double, longitude:coordinatesJArr[1] as! Double, altitude: 0, altitudeReferenceSystem: .surface)
                        results.append(poi)
                    }
                }
            }
        }
        catch {
        }

        return results;
    }
}
