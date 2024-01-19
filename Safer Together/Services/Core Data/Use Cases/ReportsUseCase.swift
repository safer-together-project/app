//
//  ReportMOUseCase.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/21/22.
//

import Foundation

protocol ReportsUseCaseProtocol {
    func reports() -> Result<[ReportDomain], Error>
    func save(report: ReportDomain) -> Result<Void, Error>
    func delete(report: ReportDomain) -> Result<Void, Error>
}

final class ReportsUseCase<Repository: AbstractRepository>: ReportsUseCaseProtocol where Repository.T == ReportDomain {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func reports() -> Result<[ReportDomain], Error> {
        return repository.query(with: nil, sortDescriptors: [NSSortDescriptor(key: "created", ascending: false)])
    }

    func save(report: ReportDomain) -> Result<Void, Error> {
        return repository.save(entity: report)
    }

    func delete(report: ReportDomain) -> Result<Void, Error> {
        return repository.delete(entity: report)
    }
}
