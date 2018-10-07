import Foundation
import Alamofire

extension AlamofireRequestBuilder {
    public func makeDataRequest() -> DataRequest {
        let mannger = createSessionManager()
        let headers = buildHeaders()
        let encoding: ParameterEncoding = isBody ? JSONDataEncoding() : URLEncoding()
        let xMethod = Alamofire.HTTPMethod(rawValue: method)!
        return makeRequest(manager: mannger, method: xMethod, encoding: encoding, headers: headers)
    }
}

