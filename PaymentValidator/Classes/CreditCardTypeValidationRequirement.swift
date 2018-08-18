//
//  CreditCardTypeValidationRequirement.swift
//  FlatPaymentMethod
//
//  Created by Ampe on 8/7/18.
//

import Foundation

struct CreditCardTypeValidationRequirement {
    let prefixes: [PrefixContainable]
    let lengths: [Int]
}

extension CreditCardTypeValidationRequirement {
    func isValid(_ accountNumber: String) -> Bool {
        return isLengthValid(accountNumber) && isPrefixValid(accountNumber)
    }
    
    func isPrefixValid(_ accountNumber: String) -> Bool {
        guard prefixes.count > 0 else {
            return true
        }
        
        return prefixes.contains { $0.hasCommonPrefix(with: accountNumber) } && isWithinValidLength(accountNumber)
    }
}

private extension CreditCardTypeValidationRequirement {
    func isLengthValid(_ accountNumber: String) -> Bool {
        guard lengths.count > 0 else {
            return true
            
        }
        
        return lengths.contains { accountNumber.count == $0 }
    }
    
    func isWithinValidLength(_ accountNumber: String) -> Bool {
        guard let largest = lengths.sorted().last else {
            assert(false, "internal inconsistency - file a bug")
            return false
        }
        
        return largest >= accountNumber.count
    }
}
