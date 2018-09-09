//
//  CreditCardType.swift
//  FlatPaymentMethod
//
//  Created by Ampe on 8/7/18.
//

import Foundation

// MARK: - Credit Card Types
public enum CreditCardType: Equatable, Hashable {
    case visa(type: VisaType)
    case amex
    case unionPay
    case mastercard
    case maestro
    case dinersClub(type: DinersClubType)
    case discover
    case jcb
    case uatp
    case dankort
    case interpayment
}

// MARK: - All Cards
public extension CreditCardType {
    public static let all: [CreditCardType] = [.visa(type: .visa),
                                               .visa(type: .electron),
                                               .amex,
                                               .unionPay,
                                               .mastercard,
                                               .maestro,
                                               .dinersClub(type: .carteBlanche),
                                               .dinersClub(type: .international),
                                               .dinersClub(type: .usbc),
                                               .discover,
                                               .jcb,
                                               .uatp,
                                               .dankort,
                                               .interpayment]
}

// MARK: - Diners Card Types
public enum DinersClubType: Equatable {
    case carteBlanche
    case international
    case usbc
}

// MARK: - Visa Card Types
public enum VisaType: Equatable {
    case visa
    case electron
}

// MARK: - Public Methods For Card Validation
public extension CreditCardType {
    func isValid(_ accountNumber: String) -> Bool {
        return requirement.isValid(accountNumber) && Mathematics.luhnCheck(accountNumber)
    }
    
    func isPrefixValid(_ accountNumber: String) -> Bool {
        return requirement.isPrefixValid(accountNumber)
    }
}

// MARK: - Public Property Methods
public extension CreditCardType {
    func segmentGrouping(for length: Int) -> [Int] {
        if let assignedGrouping = segmentGrouping[length] {
            return assignedGrouping
        } else {
            return Mathematics.defaultGrouping(for: length)
        }
    }
}

// MARK: - Public Getters
public extension CreditCardType {
    var name: String {
        switch self {
        case .amex:
            return "American Express"
        case .unionPay:
            return "Union Pay"
        case .dinersClub(let type):
            switch type {
            case .carteBlanche:
                return "Diner's Club - Carte Blanche"
            case .international:
                return "Diner's Club - International"
            case .usbc:
                return "Diner's Club - United States & Canada"
            }
        case .discover:
            return "Discover Card"
        case .jcb:
            return "JCB"
        case .maestro:
            return "Maestro"
        case .dankort:
            return "Dankort"
        case .mastercard:
            return "Mastercard"
        case .visa(let type):
            switch type {
            case .visa:
                return "Visa"
            case .electron:
                return "Visa Electron"
            }
        case .uatp:
            return "UATP"
        case .interpayment:
            return "Interpayment"
        }
    }
    
    var logoDark: UIImage? {
        switch self {
        case .amex:
            return UIImage.for(#imageLiteral(resourceName: "amex"))
        case .unionPay:
            return UIImage.for(#imageLiteral(resourceName: "union-pay"))
        case .dinersClub:
            return UIImage.for(#imageLiteral(resourceName: "diners-club"))
        case .discover:
            return UIImage.for(#imageLiteral(resourceName: "discover"))
        case .jcb:
            return UIImage.for(#imageLiteral(resourceName: "jcb"))
        case .maestro:
            return UIImage.for(#imageLiteral(resourceName: "maestro"))
        case .dankort:
            return UIImage.for(#imageLiteral(resourceName: "dankort"))
        case .mastercard:
            return UIImage.for(#imageLiteral(resourceName: "mastercard"))
        case .visa:
            return UIImage.for(#imageLiteral(resourceName: "visa"))
        case .uatp:
            return UIImage.for(#imageLiteral(resourceName: "uatp"))
        case .interpayment:
            return UIImage.for(#imageLiteral(resourceName: "interpay"))
        }
    }
}

// MARK: - Main Validation Method On Array Of Credit Card Type
public extension Array where Element == CreditCardType {
//    func validate(number: String) -> [Element] {
//        
//        forEach { card in
//            
//            guard card.isValid(number) else {
//                return
//            }
//            
//            validate(prefix: number)
//            
//        }
//    }
    
    func validate(prefix: String) -> [Element] {
        
        // have an array of credit cards and length of prefix to compare against
        // if there are multiple cards we want to find the card with the number of digits closest to the prefix length
        // need to filter out non-matching prefixes
        // if there are multiple cards with this same prefix length, return an array of cards
        var minPrefixLength: Int = 0
        var potentialCardsDictionary: [Int: Set<CreditCardType>] = [:]
        
        // itterate over every card in the array and look at the potential
        // prefixes of each card
        forEach { card in
            
            // ensure that this card has any valid prefixes
            // before continuing into the heavier lifting processes
            guard card.isPrefixValid(prefix) else {
                return
            }
            
            card.requirement.prefixes.forEach { potentialPrefix in
                
                // potential prefix matches input value
                // this is to avoid adding a card which has
                // no matching prefix to the input
                guard potentialPrefix.hasCommonPrefix(with: prefix) else {
                    return
                }
                
                // ensure potential prefix length is greater than or equal to
                // the running minimum prefix length count
                // this is to avoid adding cards with shorter prefixes
                // when the prefix matches a more specific prefix
                guard potentialPrefix.count >= minPrefixLength else {
                    return
                }
                
                // add card belonging to potential prefix to the dictionary
                // of potential cards with a value of the potential
                // prefixes length
                if potentialCardsDictionary[potentialPrefix.count] != nil {
                    potentialCardsDictionary[potentialPrefix.count]?.insert(card)
                } else {
                    potentialCardsDictionary[potentialPrefix.count] = [card]
                }
                
                // ensure the length of the potential prefix does not
                // exceed that of the entered prefix
                // this is to avoid having a minimum prefix length
                // which is larger than the current length of the entered
                // prefix
                // if this were to happen, we would exclude cards which
                // shoud still be included in the set of potential cards
                guard potentialPrefix.count <= prefix.count  else {
                    return
                }
                
                // update the minimum prefix length to that of the
                // potential prefix length
                minPrefixLength = potentialPrefix.count
            }
        }
        
        // we want to include all cards with the minPrefixLength
        // as well as all cards with potentialPrefix values longer
        // than the minPrefixLength
        var possibleCards: Set<CreditCardType> = []
        
        // extract all lengths from the dictionary
        potentialCardsDictionary.keys
            .filter { length in
                // take all lengths equal to or larger than the minimum prefix length
                length >= minPrefixLength
            }.forEach { length in
                // extract cards for these lengths from the dictionary
                guard let cards = potentialCardsDictionary[length] else {
                    return
                }
                // construct array of cards from these values
                cards.forEach { card in
                    possibleCards.insert(card)
                }
        }
        
        return Array(possibleCards)
    }
}

// MARK: - Constants For Determining Card Type
private extension CreditCardType {
    // per https://baymard.com/checkout-usability/credit-card-patterns
    // Feb 3, 2017 article publish date
    // Aug 7, 2018 implementation date
    // Aug 7, 2018 implementation updated date
    var requirement: CreditCardTypeValidationRequirement {
        let prefixes: [PrefixContainable]
        let lengths: [Int]
        
        switch self {
        case .amex:
            prefixes = ["34", "37"]
            lengths = [15]
        case .unionPay:
            prefixes = ["62"]
            lengths = [16, 17, 18, 19]
        case .dinersClub(let type):
            switch type {
            case .carteBlanche:
                prefixes = ["300"..."305"]
                lengths = [14]
            case .international:
                prefixes = ["309", "36", "38"..."39"]
                lengths = [14]
            case .usbc:
                prefixes = ["54", "55"]
                lengths = [16]
            }
        case .discover:
            prefixes = ["6011", "622126"..."622925", "644"..."649", "65"]
            lengths = [16]
        case .jcb:
            prefixes = ["3528"..."3589"]
            lengths = [16]
        case .maestro:
            prefixes = ["500000"..."509999", "560000"..."589999", "600000"..."699999"]
            lengths = [12, 13, 14, 15, 16, 17, 18, 19]
        case .dankort:
            prefixes = ["5019"]
            lengths = [16]
        case .mastercard:
            prefixes = ["51"..."55"]
            lengths = [16]
        case .visa(let type):
            switch type {
            case .visa:
                prefixes = ["4"]
                lengths = [13, 14, 15, 16, 17, 18, 19]
            case .electron:
                prefixes = ["4026", "417500", "4405", "4508", "4844", "4913", "4917"]
                lengths = [16]
            }
        case .uatp:
            prefixes = ["1"]
            lengths = [15]
        case .interpayment:
            prefixes = ["636"]
            lengths = [16, 17, 18, 19]
        }
        
        return CreditCardTypeValidationRequirement(prefixes: prefixes, lengths: lengths)
    }
    
    // per https://baymard.com/checkout-usability/credit-card-patterns
    // Feb 3, 2017 article publish date
    // Aug 7, 2018 implementation date
    // Aug 7, 2018 implementation updated date
    var segmentGrouping: [Int: [Int]] {
        switch self {
        case .amex:
            return [16: [4, 6, 5]]
        case .unionPay:
            return [16: [4, 4, 4, 4],
                    19: [6, 13]]
        case .dinersClub(let type):
            switch type {
            case .carteBlanche:
                return [14: [4, 6, 4]]
            case .international:
                return [14: [4, 6, 4]]
            case .usbc:
                return [16: [4, 4, 4, 4]]
            }
        case .discover:
            return [16: [4, 4, 4, 4]]
        case .jcb:
            return [16: [4, 4, 4, 4]]
        case .maestro:
            return [13: [4, 4, 5],
                    15: [4, 6, 5],
                    16: [4, 4, 4, 4],
                    19: [4, 4, 4, 4, 3]]
        case .dankort:
            return [16: [4, 4, 4, 4]]
        case .mastercard:
            return [16: [4, 4, 4, 4]]
        case .visa(let type):
            switch type {
            case .visa:
                return [16: [4, 4, 4, 4]]
            case .electron:
                return [16: [4, 4, 4, 4]]
            }
        case .uatp:
            return [15: [4, 5, 6]]
        case .interpayment:
            return [16: [4, 4, 4, 4]]
        }
    }
    
    // per scraping the internet
    // Aug 7, 2018 implementation date
    // Aug 7, 2018 implementation updated date
    var cvvLength: Int {
        switch self {
        case .amex:
            return 4
        default:
            return 3
        }
    }
}
