//
//  ExposuresUseCase.swift
//  Steds Care
//
//  Created by Erik Bautista on 1/22/22.
//

import Foundation

protocol ExposuresUseCaseProtocol {
    func exposures() -> Result<[ExposedDomain], Error>
    func save(exposed: ExposedDomain) -> Result<Void, Error>
    func delete(exposed: ExposedDomain) -> Result<Void, Error>
}

final class ExposuresUseCase<Repository: AbstractRepository>: ExposuresUseCaseProtocol where Repository.T == ExposedDomain {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func exposures() -> Result<[ExposedDomain], Error> {
        return repository.query(with: nil, sortDescriptors: [NSSortDescriptor(key: "exposedDate", ascending: false)])
    }

    func save(exposed: ExposedDomain) -> Result<Void, Error> {
        return repository.save(entity: exposed)
    }

    func delete(exposed: ExposedDomain) -> Result<Void, Error> {
        return repository.delete(entity: exposed)
    }
}
