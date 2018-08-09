//
//  FlatFieldConfig.swift
//  FlatField
//
//  Created by Ampe on 7/29/18.
//

import UIKit

// MARK: - Config For Flat Field
public struct FlatFieldConfig {
    public let text: String
    public let placeholderText: String
    public let cursorColor: UIColor
    public let textColor: UIColor
    public let placeholderColor: UIColor
    public let underlineColor: UIColor
    public let underlineThickness: CGFloat
    public let thicknessChange: CGFloat
    public let textAlignment: NSTextAlignment
    
    public init(text: String,
                placeholderText: String,
                cursorColor: UIColor,
                textColor: UIColor,
                placeholderColor: UIColor,
                underlineColor: UIColor,
                underlineThickness: CGFloat,
                thicknessChange: CGFloat,
                textAlignment: NSTextAlignment) {
        
        self.text = text
        self.placeholderText = placeholderText
        self.cursorColor = cursorColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.underlineColor = underlineColor
        self.underlineThickness = underlineThickness
        self.thicknessChange = thicknessChange
        self.textAlignment = textAlignment
    }
    
    public init(placeholderText: String) {
        self.init(text: "",
                  placeholderText: placeholderText,
                  cursorColor: .gray,
                  textColor: .black,
                  placeholderColor: .gray,
                  underlineColor: .gray,
                  underlineThickness: 1.0,
                  thicknessChange: 1.0,
                  textAlignment: .left)
    }
    
    public static let `default` = FlatFieldConfig(placeholderText: "Placeholder")
}
