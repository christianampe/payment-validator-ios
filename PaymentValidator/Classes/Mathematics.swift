//
//  Mathematics.swift
//  FlatPaymentMethod
//
//  Created by Ampe on 8/8/18.
//

import Foundation

struct Mathematics {
    static let defaultSegmentSize: Int = 4
}

// MARK: - Default Grouping Logic
extension Mathematics {
    static func defaultGrouping(for length: Int) -> [Int] {
        var defaultGrouping: [Int]
        
        let fullSegments: Int = Int(Double(length / defaultSegmentSize).rounded(.down))
        let remainder: Int = length % defaultSegmentSize
        
        let fullSegmentArray: [Int] = Array(repeating: defaultSegmentSize, count: fullSegments)
        
        defaultGrouping = fullSegmentArray
        
        if remainder > 0 {
            guard remainder < defaultSegmentSize else {
                assert(false, "internal inconsistency - file a bug")
                return defaultGrouping
            }
            
            defaultGrouping.append(remainder)
        }
        
        return defaultGrouping
    }
}

// MARK: - Luhn Check
extension Mathematics {
    // per https://gist.github.com/cwagdev/635ce973e8e86da0403a
    static func luhnCheck(_ cardNumber: String) -> Bool {
        var sum: Int = 0
        for (idx, element) in (cardNumber.reversed().map { String($0) }).enumerated() {
            guard let digit = Int(element) else {
                return false
            }
            
            switch ((idx % 2 == 1), digit) {
            case (true, 9):
                sum += 9
            case (true, 0...8):
                sum += (digit * 2) % 9
            default:
                sum += digit
            }
        }
        
        return sum % 10 == 0
    }
}
