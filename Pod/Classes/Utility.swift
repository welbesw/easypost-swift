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
}
