//
//  CreditCardTypeValidationState.swift
//  FlatPaymentMethod
//
//  Created by Ampe on 8/7/18.
//

import Foundation

public enum CreditCardTypeValidationState: Equatable {
    case identified(CreditCardType)
    case indeterminate(cards: [CreditCardType])
    case unsupported(cards: [CreditCardType])
    case invalid
}

// MARK: - Initalizers
extension CreditCardTypeValidationState {
    
    /// init to be used on a fully entered credit card
    /// use when the card number has been fully entered
    init(fromNumber number: String, supportedCards: [CreditCardType]) {
        
        // ensure that there are cards that can be supported
        guard supportedCards.count > 0 else {
            self = .unsupported(cards: CreditCardType.all)
            return
        }
        
        // run all cards through full validation
        let cards = CreditCardType.all.filter { $0.isValid(number) }
        
        // ensure the result of validation yields at least one card
        guard cards.count > 0 else {
            self = .invalid
            return
        }
        
        // extract the first card from the valid card array
        // there should never be more than one card in this array
        // if there is return an indetermine result
        guard let card = cards.first else {
            self = .indeterminate(cards: cards)
            return
        }
        
        // make sure the identified card is contained
        // in the list of supported cards
        // otherwise return an unsupported result
        guard supportedCards.contains(card) else {
            self = .unsupported(cards: [card])
            return
        }
        
        // if all these checks succeed
        // the card has been identified
        self = .identified(card)
    }
    
    /// init to be used on a prefix value of a credit card
    /// use when the user is entering the account number
    init(fromPrefix prefix: String, supportedCards: [CreditCardType]) {
        
        // ensure that there are cards that can be supported
        guard supportedCards.count > 0 else {
            self = .unsupported(cards: CreditCardType.all)
            return
        }
        
        // this is where the heavy lifting happens
        // we diff all card prefixes against the entered prefix
        // returns an array of valid card types
        let validCardTypes = CreditCardType.all.validate(prefix: prefix)
        
        // if no cards match we know no card currently in circulation
        // can match the prefix
        // throw an invalid state
        guard validCardTypes.count > 0 else {
            self = .invalid
            return
        }
        
        // construct sets of the valid card diff computed above
        // and calculate its intersect against the set of supported
        // cards provided by the client
        // intersection returns the values which are contained in
        // both sets
        let possibleSet: Set<CreditCardType> = Set(validCardTypes)
        let supportedSet: Set<CreditCardType> = Set(supportedCards)
        
        // perform the intersection operation
        // this returns a set which contains a list of all the
        // cards that are supported by the client and match the
        // prefix entered
        let supportedValidCardTypes: Set<CreditCardType> = supportedSet.intersection(possibleSet)
        
        // if there are no like type cards returned from the join
        // this tells us the vendor does not support the card/cards
        // that matched the prefix
        guard supportedValidCardTypes.count > 0 else {
            self = .unsupported(cards: validCardTypes)
            return
        }
        
        // if there is only one card returned by the intersection operation
        // we know that this a card that can be identified
        // otherwise there are multiple cards returned by this intersection
        // operation which we return to the client with an indeterminate state
        // with an associated value of an array of potentially valid card types
        if supportedValidCardTypes.count == 1 {
            guard let card = supportedValidCardTypes.first else {
                assert(false, "internal inconsistency - file a bug")
                self = .invalid
                return
            }
            
            self = .identified(card)
        } else {
            self = .indeterminate(cards: Array(supportedValidCardTypes))
        }
    }
}

public extension CreditCardTypeValidationState {
    var cards: [CreditCardType]? {
        switch self {
        case .identified(let identifiedCard):
            return [identifiedCard]
        case .indeterminate(let identifiedCards):
            return identifiedCards
        default:
            return nil
        }
    }
}

public extension CreditCardTypeValidationState {
    func segmentGrouping(for length: Int) -> [Int]? {
        switch self {
        case .identified(let card):
            return card.segmentGrouping(for: length)
        case .indeterminate:
            return Mathematics.defaultGrouping(for: length)
        case .unsupported(let cards):
            if cards.count == 1, let card = cards.first {
                return card.segmentGrouping(for: length)
            } else {
                return Mathematics.defaultGrouping(for: length)
            }
        case .invalid:
            return nil
        }
    }
}
