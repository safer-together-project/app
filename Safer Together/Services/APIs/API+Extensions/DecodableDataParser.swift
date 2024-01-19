//
//  DecodableDataParser.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/14/21.
//

import Foundation
import APIKit

final class DecodableDataParser: DataParser {

    var contentType: String? {
        return "application/json"
    }

    func parse(data: Data) throws -> Any {
        return data
    }
}
