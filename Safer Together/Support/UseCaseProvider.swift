//
//  UseCaseProvider.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/21/22.
//

import Foundation


final class UseCaseProvider {
    private let coreDataStack: CoreDataStack
    private let reportsRepository: Repository<ReportDomain>
    private let exposedRepository: Repository<ExposedDomain>

    init() {
        coreDataStack = CoreDataStack()
        reportsRepository = Repository<ReportDomain>(context: coreDataStack.context)
        exposedRepository = Repository<ExposedDomain>(context: coreDataStack.context)
    }

    func makeReportsRepository() -> ReportsUseCaseProtocol {
        return ReportsUseCase(repository: reportsRepository)
    }

    func makeExposuresRepository() -> ExposuresUseCaseProtocol {
        return ExposuresUseCase(repository: exposedRepository)
    }
}
