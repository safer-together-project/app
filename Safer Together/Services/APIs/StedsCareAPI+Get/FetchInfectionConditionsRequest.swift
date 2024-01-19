//
//  FetchInfectionConditionsRequest.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import APIKit


extension StedsCareAPI {
    struct FetchInfectionConditionsRequest: StedsCareRequest {
        let organizationId: Int

        typealias Response = [InfectionCondition]

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/infection_conditions/\(organizationId)"
        }

        func response(from object: Any, urlResponse: HTTPURLResponse) throws -> Response {
            guard let data = object as? Data else {
                throw ResponseError.unexpectedObject(object)
            }
            return try decoder.decode(Response.self, from: data)
        }
    }
}
