import Foundation
import Alamofire

extension AlamofireRequestBuilder {
    public func makeDataRequest() -> DataRequest {
        let mannger = createSessionManager()
        let headers = buildHeaders()
        let xMethod = Alamofire.HTTPMethod(rawValue: method)!
        let encoding: ParameterEncoding
        switch xMethod {
        case .get, .head:
            encoding = URLEncoding()
        case .options, .post, .put, .patch, .delete, .trace, .connect:
            encoding = JSONDataEncoding()
        }
        return makeRequest(manager: mannger, method: xMethod, encoding: encoding, headers: headers)
    }
}
