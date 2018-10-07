import Foundation
import Alamofire

#if DEBUG
extension AlamofireRequestBuilder {
    public var cURLString: String {
        return makeDataRequest().request?.cURLString ?? ""
    }
}
#endif
