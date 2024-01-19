//
//  Application.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/21/22.
//

import Foundation

final class Application {
    static let shared = Application()
    let services: UseCaseProvider

    private init() {
        services = UseCaseProvider()
    }
}
