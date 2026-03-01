//
//  GetAllCreditsUseCase.swift
//  Racoon-Employee
//
//  Created by dark type on 01.03.2026.
//


public protocol GetAllCreditsUseCase: Sendable {
    func callAsFunction() async throws -> [Credit]
}

public struct GetAllCreditsUseCaseImpl: GetAllCreditsUseCase {
    private let repo: EmployeeCreditsRepository

    public init(repo: EmployeeCreditsRepository) { self.repo = repo }

    public func callAsFunction() async throws -> [Credit] {
        let dtos = try await repo.allCredits()
        return dtos.map(CreditMapper.toDomain)
    }
}