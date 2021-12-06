//
//  EasyPostExtensions.swift
//  Pods
//
//  Created by William Welbes on 10/6/15.
//
//

import Foundation

//Defined the += operator for adding two dictionaries together
func += <KeyType, ValueType> (left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}
