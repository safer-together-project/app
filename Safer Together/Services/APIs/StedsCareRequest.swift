//
//  StedsCareRequest.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/14/21.
//

import Foundation
import APIKit

protocol StedsCareRequest: Request {}

extension StedsCareRequest {
    var baseURL: URL {
        return URL(string: APIConstants.BASE)!
    }

    var dataParser: DataParser {
        return DecodableDataParser()
    }

    var decoder: JSONDecoder {
        return JSONDecoder()
    }
}

extension StedsCareRequest where Response: Decodable & CustomDecodingStrategy {
    func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
        guard let data = object as? Data else {
            throw ResponseError.unexpectedObject(object)
        }
        return try decoder.decode(Response.self, from: data)
    }
}

extension StedsCareRequest where Response: Encodable & CustomEncodingStrategy {
    var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        let strategies = Response.encodingStrategies
        encoder.dateEncodingStrategy = strategies.dateEncodingStrategy
        encoder.dataEncodingStrategy = strategies.dataEncodingStrategy
        encoder.nonConformingFloatEncodingStrategy = strategies.nonConformingFloatDecodingStrategy
        return encoder
    }
}

extension StedsCareRequest where Response: CustomDecodingStrategy {
    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        let strategies = Response.decodingStrategies
        decoder.dateDecodingStrategy = strategies.dateDecodingStrategy
        decoder.dataDecodingStrategy = strategies.dataDecodingStrategy
        decoder.nonConformingFloatDecodingStrategy = strategies.nonConformingFloatDecodingStrategy
        return decoder
    }
}
