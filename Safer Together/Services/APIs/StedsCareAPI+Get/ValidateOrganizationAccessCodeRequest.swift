//
//  ValidateOrganizationAccessCodeRequest.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import APIKit

extension StedsCareAPI {
    // Check Organization access code
    struct ValidateOrganizationAccessCodeRequest: StedsCareRequest {
        let accessCode: String

        typealias Response = Organization

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/organization/" + accessCode
        }
    }
}
