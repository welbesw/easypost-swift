//
//  UrlRequest.swift
//  EasyPostApi
//
//  Created by William Welbes on 11/20/17.
//

import Foundation

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

extension URLRequest {

    static func newRequest(urlString: String, method: HTTPMethod, parameters: [String: String]? = nil, headers: [String: String]) -> URLRequest? {

        guard let url = URL(string: urlString) else {
            return nil
        }

        var request = URLRequest(url: url)

        //If parameters are specified, add them to the http body
        if let parameters = parameters {
            if method == .get {
                var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                var queryItems = [URLQueryItem]()
                for parameter in parameters {
                    queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
                }

                urlComponents?.queryItems = queryItems
                if let urlWithComponents = urlComponents?.url {
                    request.url = urlWithComponents
                }

            } else {
                var parametersStrings = [String]()
                //Loop over the parameters and create the parameters
                for parameter in parameters {
                    parametersStrings.append("\(Utility.percentEscapeString(parameter.key))=\(Utility.percentEscapeString(parameter.value))")
                }

                request.httpBody = parametersStrings.joined(separator: "&").data(using: .utf8)

                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            }
        }

        request.setupForAuthorization(httpMethod: method, httpHeaders: headers)

        return request
    }

    mutating func setupForAuthorization(httpMethod: HTTPMethod, httpHeaders: [String: String]) {

        self.httpMethod = httpMethod.rawValue
        self.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData

        for (headerKey, headerValue) in httpHeaders {
            self.addValue(headerValue, forHTTPHeaderField: headerKey)
        }
    }
}
