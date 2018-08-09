//
//  PrefixContainable.swift
//  FlatPaymentMethod
//
//  Created by Ampe on 8/7/18.
//

import Foundation

// MARK: - Structure To Handle Prefixes
public protocol PrefixContainable {
    func hasCommonPrefix(with text: String) -> Bool
    var count: Int { get }
}

extension ClosedRange: PrefixContainable {
    public func hasCommonPrefix(with text: String) -> Bool {
        guard
            let lower = lowerBound as? String,
            let upper = upperBound as? String
            else {
                return false
        }
        
        let trimmedRange: ClosedRange<String> = {
            let length = text.count
            let trimmedStart = lower.prefix(length)
            let trimmedEnd = upper.prefix(length)
            return trimmedStart...trimmedEnd
        }()
        
        let trimmedText = text.prefix(trimmedRange.lowerBound.count)
        
        return trimmedRange ~= trimmedText
    }
    
    public var count: Int {
        guard let upperBoundString = upperBound as? String else {
            assert(false, "improper use - only use this value on a string closed range")
            return -1
        }
        
        return upperBoundString.count
    }
}

extension String: PrefixContainable {
    public func hasCommonPrefix(with text: String) -> Bool {
        return hasPrefix(text) || text.hasPrefix(self)
    }
}

fileprivate extension String {
    func prefix(_ maxLength: Int) -> String {
        return String(characters.prefix(maxLength))
    }
}
