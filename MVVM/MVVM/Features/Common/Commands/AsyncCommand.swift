//
//  AsyncCommand.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

protocol AsyncCommand {
    associatedtype ReturnType
    func execute() async throws -> ReturnType
}
