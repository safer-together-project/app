//
//  Array+CustomDecodingStrategy.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/19/22.
//

import Foundation

extension Array: CustomDecodingStrategy where Element: CustomDecodingStrategy {
    static var decodingStrategies: (DecodingStrategies) {
        Element.decodingStrategies
    }
}

extension Array: CustomEncodingStrategy where Element: CustomEncodingStrategy {
    static var encodingStrategies: (EncodingStrategies) {
        Element.encodingStrategies
    }
}
