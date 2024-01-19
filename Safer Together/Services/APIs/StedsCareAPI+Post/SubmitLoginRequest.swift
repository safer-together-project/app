//
//  SubmitLoginRequest.swift
//  Safer Together
//
//  Created by Erik Bautista on 2/21/22.
//

import Foundation
import APIKit


extension StedsCareAPI {
    // Submit Report with Path
    struct SubmitLoginRequest: StedsCareRequest {
        let username: String
        let password: String

        typealias Response = Employee

        var method: HTTPMethod {
            return .post
        }

        var path: String {
            return "/login"
        }

        var bodyParameters: BodyParameters? {
            let arr = [
                "username": username,
                "password": password
            ]
            let bodyParams = FormURLEncodedBodyParameters(formObject: arr)
            return bodyParams
        }
    }
}
