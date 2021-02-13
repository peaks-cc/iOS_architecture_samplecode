import Foundation
import Alamofire

#if DEBUG
extension AlamofireRequestBuilder {
    // func createURLRequest() -> URLRequest? {
    //     let xMethod = Alamofire.HTTPMethod(rawValue: method)!
    //     let encoding: ParameterEncoding
    //     switch xMethod {
    //     case .get, .head:
    //         encoding = URLEncoding()
    //     case .options, .post, .put, .patch, .delete, .trace, .connect:
    //         encoding = JSONDataEncoding()
    //     }
    //     guard let originalRequest = try? URLRequest(url: URLString, method: HTTPMethod(rawValue: method)!, headers: buildHeaders()) else { return nil }
    //     return try? encoding.encode(originalRequest, with: parameters)
    // }

    public var cURLString: String {
        return createURLRequest()?.cURLString ?? ""
    }
}
#endif
