//
//  EasyPostResult.swift
//  Pods
//
//  Created by William Welbes on 10/5/15.
//
//

import Foundation

public enum EasyPostResult<Value> {
    case Success(Value)
    case Failure(ErrorType)
    
    /// Returns `true` if the result is a success, `false` otherwise.
    public var isSuccess: Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    
    /// Returns `true` if the result is a failure, `false` otherwise.
    public var isFailure: Bool {
        return !isSuccess
    }
    
    /// Returns the associated value if the result is a success, `nil` otherwise.
    public var value: Value? {
        switch self {
        case .Success(let value):
            return value
        case .Failure:
            return nil
        }
    }
    
    /// Returns the associated error value if the result is a failure, `nil` otherwise.
    public var error: ErrorType? {
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
}