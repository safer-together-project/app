//
//  StedsCareAPI.swift
//  Steds Care
//
//  Created by Erik Bautista on 11/14/21.
//

import Foundation
import APIKit


public final class StedsCareAPI {}

func printError(_ error: SessionTaskError) {
    switch error {
    case .connectionError(let error):
        print("Connection error: \(error)")
    default:
        print("System error : \(error)")
    }
}
