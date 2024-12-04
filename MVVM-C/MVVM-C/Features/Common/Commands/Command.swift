//
//  Command.swift
//  NeoVault
//
//  Created by James Wolfe on 15/11/2024.
//

protocol Command {
    associatedtype ReturnType
    func execute() throws -> ReturnType
}
