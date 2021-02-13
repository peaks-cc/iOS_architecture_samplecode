import UIKit
import XCTest
import Mockingjay
import GitHubAPI

// swiftlint:disable force_cast
// swiftlint:disable force_try
extension XCTestCase {
    func fixtureData(_ resource: String) -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: resource, withExtension: nil) else {
            fatalError("'\(resource)' not found in bundle")
        }
        do {
            return try Data(contentsOf: url)
        } catch {
            fatalError("Cannot load '\(resource)'")
        }
    }

    func fixtureData(_ resource: String, modification: (_ json: [String: Any]) -> [String: Any]) -> Data {
        let json = try! JSONSerialization.jsonObject(with: fixtureData(resource), options: .allowFragments) as! [String: Any]
        return try! JSONSerialization.data(withJSONObject: modification(json), options: .prettyPrinted)
    }

    func fixtureDict(_ dict: [String: Any]) -> Data {
        let data = try! JSONSerialization.data(withJSONObject: dict, options: [])
        return data
    }

    func fixtureObject<T>(_ resource: String)-> Swift.Result<T, Error> where T: Decodable {
        return CodableHelper.decode(T.self, from: fixtureData(resource))
    }
}
