//
//  UpdateInfectionConditionRequest.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import APIKit

extension StedsCareAPI {
    // Submit Report with Path
    struct UpdateInfectionConditionRequest: StedsCareRequest {
        let condition: InfectionCondition

        typealias Response = InfectionCondition

        var method: HTTPMethod {
            return .patch
        }

        var path: String {
            return "/infection_conditions/condition/\(condition.id)"
        }

        var bodyParameters: BodyParameters? {
            if let jsonData = try? encoder.encode(condition) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    return JSONBodyParameters(JSONObject: jsonObject)
                }
            }
            return nil
        }
    }
}
