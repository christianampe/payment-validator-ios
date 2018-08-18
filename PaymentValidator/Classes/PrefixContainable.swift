//
//  PrefixContainable.swift
//  FlatPaymentMethod
//
//  Created by Ampe on 8/7/18.
//

import Foundation

// MARK: - Structure To Handle Prefixes
protocol PrefixContainable {
    func hasCommonPrefix(with text: String) -> Bool
    var count: Int { get }
}

extension ClosedRange: PrefixContainable {
    func hasCommonPrefix(with text: String) -> Bool {
        guard
            let lower = lowerBound as? String,
            let upper = upperBound as? String
            else {
                return false
        }
        
        let trimmedRange: ClosedRange<String> = {
            let length = text.count
            let trimmedStart = String(lower.prefix(length))
            let trimmedEnd = String(upper.prefix(length))
            return trimmedStart...trimmedEnd
        }()
        
        let trimmedText = String(text.prefix(trimmedRange.lowerBound.count))
        
        return trimmedRange ~= trimmedText
    }
    
    var count: Int {
        guard let upperBoundString = upperBound as? String else {
            assert(false, "improper use - only use this value on a string closed range")
            return -1
        }
        
        return upperBoundString.count
    }
}

extension String: PrefixContainable {
    func hasCommonPrefix(with text: String) -> Bool {
        return hasPrefix(text) || text.hasPrefix(self)
    }
}
