// @see https://github.com/dduan/cURLLook/blob/master/cURLLook/NSURLRequestCURLRepresentation.swift
import Foundation

extension URLRequest {
    /*
     Convenience property, the value of calling `cURLRepresentation()` with no arguments.
     */
    public var cURLString: String {
        return cURLRepresentation()
    }

    /*
     cURL (http://http://curl.haxx.se) is a commandline tool that makes network requests. This method serializes a `NSURLRequest` to a cURL
     command that performs the same HTTP request.
     - Parameter session:    *optional* the `NSURLSession` this NSURLRequest is being used with. Extra information from the session such as
     cookies and credentials may be included in the result.
     - Parameter credential: *optional* the credential to include in the result. The value of `session?.configuration.URLCredentialStorage`,
     when present, would override this argument.
     - Returns:              a string whose value is a cURL command that would perform the same HTTP request this object represents.
     */
    public func cURLRepresentation(withURLSession session: URLSession? = nil, credential: URLCredential? = nil) -> String {
        var components: [String] = ["curl"]
        let URL = self.url
        if let httpMethod = httpMethod {
            components.append("-X \(String(describing: httpMethod))")
        }

        if let session = session, session.configuration.httpShouldSetCookies {
            if let cookieStorage = session.configuration.httpCookieStorage,
                let cookies: [HTTPCookie] = cookieStorage.cookies(for: URL!), cookies.isEmpty == false {
                let string = cookies.reduce("") { (initialResult: String, nextPartialResult: HTTPCookie) -> String in
                    return "\(initialResult)\(nextPartialResult.name)=\(nextPartialResult.value);"
                }
                let index = string.index(before: string.endIndex)
                let prefix = String(describing: string.prefix(upTo: index))
                components.append("-b \"\(prefix)\"")
            }
        }

        if let headerFields = self.allHTTPHeaderFields {
            for (field, value) in headerFields {
                if field == "Cookie" { continue }
                if value.contains("gzip") { continue }
                components.append("-H \"\(field): \(value)\"")
            }
        }

        if let session = session, let additionalHeaders = session.configuration.httpAdditionalHeaders as? [String: String] {
            for (field, value) in additionalHeaders {
                if field == "Cookie" { continue }
                components.append("-H \"\(field): \(value)\"")
            }
        }

        if let HTTPBodyData = httpBody,
            let HTTPBody = NSString(data: HTTPBodyData, encoding: String.Encoding.utf8.rawValue) {
            let escapedBody = HTTPBody.replacingOccurrences(of: "\"", with: "\\\"")
            components.append("-d \"\(escapedBody)\"")
        }

        if let URL = URL {
            components.append("\"\(URL.absoluteString)\"")
        }
        return components.joined(separator: " \\\n\t")
    }
}
