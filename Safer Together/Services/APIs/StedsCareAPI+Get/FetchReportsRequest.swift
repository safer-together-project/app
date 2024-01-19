//
//  FetchReportsRequest.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import APIKit

extension StedsCareAPI {
    struct FetchReportsRequest: StedsCareRequest {
        let organization: Organization

        typealias Response = [Report]

        var method: HTTPMethod {
            return .get
        }

        var path: String {
            return "/reports/\(organization.id)"
        }
    }
}
