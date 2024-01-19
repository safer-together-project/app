//
//  SubmitReportRequest.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import APIKit

extension StedsCareAPI {
    // Submit Report with Path
    struct SubmitReportRequest: StedsCareRequest {
        let report: Report

        typealias Response = Report

        var method: HTTPMethod {
            return .post
        }

        var path: String {
            return "/reports/report"
        }

        var bodyParameters: BodyParameters? {
            if let jsonData = try? encoder.encode(report) {
                if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) {
                    return JSONBodyParameters(JSONObject: jsonObject)
                }
            }

            return nil
        }
    }
}
