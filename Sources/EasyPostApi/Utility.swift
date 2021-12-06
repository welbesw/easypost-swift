//
//  Utility.swift
//  EasyPostApi
//
//  Created by William Welbes on 11/20/17.
//

import Foundation

class Utility {

    static let errorDomain = "com.technomagination.EasyPostApi"

    static func error(_ message: String, code: Int = 0) -> NSError {

        let customError = NSError(domain: errorDomain, code: code, userInfo: [
            NSLocalizedDescriptionKey: message,
            ])

        return customError
    }

    static func percentEscapeString(_ string: String) -> String {

        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")

        guard let escapedString = string.addingPercentEncoding(withAllowedCharacters: characterSet)?.replacingOccurrences(of: " ", with: "+", options: [], range: nil) else {
            return string
        }

        return escapedString
    }
    
    class func logRequest(_ request: URLRequest){
        
        let urlString = request.url?.absoluteString ?? ""
        let components = NSURLComponents(string: urlString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod!)": ""
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        let host = "\(components?.host ?? "")"
        
        var requestLog = "\n---------- WEB REQUEST ---------->\n"
        requestLog += "\(urlString)"
        requestLog += "\n\n"
        requestLog += "\(method) \(path)?\(query) HTTP/1.1\n"
        requestLog += "Host: \(host)\n"
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            requestLog += "\(key): \(value)\n"
        }
        if let body = request.httpBody{
            requestLog += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue)!)\n"
        }
        
        requestLog += "\n------------------------->\n";
        print(requestLog)
    }
    
    class func logResponse(data: Data?, response: URLResponse?, error: Error?) {
        guard let response = response as? HTTPURLResponse else {
            return
        }
        let urlString = response.url?.absoluteString
        let components = NSURLComponents(string: urlString ?? "")
        
        let path = "\(components?.path ?? "")"
        let query = "\(components?.query ?? "")"
        
        var responseLog = "\n<---------- WEB RESPONSE ----------\n"
        if let urlString = urlString {
            responseLog += "\(urlString)"
            responseLog += "\n\n"
        }
        
        responseLog += "HTTP \(response.statusCode) \(path)?\(query)\n"
        
        if let host = components?.host {
            responseLog += "Host: \(host)\n"
        }
        for (key,value) in response.allHeaderFields {
            responseLog += "\(key): \(value)\n"
        }
        if let body = data{
            responseLog += "\n\(NSString(data: body, encoding: String.Encoding.utf8.rawValue)!)\n"
        }
        if error != nil{
            responseLog += "\nError: \(error!.localizedDescription)\n"
        }
        
        responseLog += "<------------------------\n";
        print(responseLog)
    }
}
