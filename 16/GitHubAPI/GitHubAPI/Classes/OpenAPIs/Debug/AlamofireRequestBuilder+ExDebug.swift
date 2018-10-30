import Foundation
import Alamofire

#if DEBUG
extension AlamofireRequestBuilder {
    func createURLRequest() -> URLRequest? {
        let encoding: ParameterEncoding = isBody ? JSONDataEncoding() : URLEncoding()
        guard let originalRequest = try? URLRequest(url: URLString, method: HTTPMethod(rawValue: method)!, headers: buildHeaders()) else { return nil }
        return try? encoding.encode(originalRequest, with: parameters)
    }

    public var cURLString: String {
        return createURLRequest()?.cURLString ?? ""
    }
}
#endif
