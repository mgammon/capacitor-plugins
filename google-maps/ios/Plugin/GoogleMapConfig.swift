import Foundation
import Capacitor

struct CustomMapType {
    var id: String;
    var url: String;
}

public struct GoogleMapConfig: Codable {
    let width: Double
    let height: Double
    let x: Double
    let y: Double
    let center: LatLng
    let zoom: Double
    let styles: String?
    var customMapTypes: [String: String] = [:]

    init(fromJSObject: JSObject) throws {
        guard let width = fromJSObject["width"] as? Double else {
            throw GoogleMapErrors.invalidArguments("GoogleMapConfig object is missing the required 'width' property")
        }

        guard let height = fromJSObject["height"] as? Double else {
            throw GoogleMapErrors.invalidArguments("GoogleMapConfig object is missing the required 'height' property")
        }

        guard let x = fromJSObject["x"] as? Double else {
            throw GoogleMapErrors.invalidArguments("GoogleMapConfig object is missing the required 'x' property")
        }

        guard let y = fromJSObject["y"] as? Double else {
            throw GoogleMapErrors.invalidArguments("GoogleMapConfig object is missing the required 'y' property")
        }

        guard let zoom = fromJSObject["zoom"] as? Double else {
            throw GoogleMapErrors.invalidArguments("GoogleMapConfig object is missing the required 'zoom' property")
        }

        guard let latLngObj = fromJSObject["center"] as? JSObject else {
            throw GoogleMapErrors.invalidArguments("GoogleMapConfig object is missing the required 'center' property")
        }

        guard let lat = latLngObj["lat"] as? Double, let lng = latLngObj["lng"] as? Double else {
            throw GoogleMapErrors.invalidArguments("LatLng object is missing the required 'lat' and/or 'lng' property")
        }

        self.width = round(width)
        self.height = round(height)
        self.x = x
        self.y = y
        self.zoom = zoom
        self.center = LatLng(lat: lat, lng: lng)
        if let stylesArray = fromJSObject["styles"] as? JSArray, let jsonData = try? JSONSerialization.data(withJSONObject: stylesArray, options: []) {
            self.styles = String(data: jsonData, encoding: .utf8)
        } else {
            self.styles = nil
        }
        
        // This is super verbose but like, I'm real bad at Swift, and this works.
        let customMapTypesArray = fromJSObject["customMapTypes"] as? JSArray
        if customMapTypesArray != nil {
            for customMapTypeJSObject in customMapTypesArray! {
                let customMapType = customMapTypeJSObject as? JSObject
                if (customMapType != nil){
                    let id = customMapType!["id"] as? String;
                    let url = customMapType!["url"] as? String;
                    if (id != nil && url != nil){
                        self.customMapTypes[id!] = url
                    }
                }
            }
        }
    }
}
