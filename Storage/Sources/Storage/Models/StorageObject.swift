//
//  StorageObject.swift
//  Storage
//
//  Created by James Wolfe on 02/12/2024.
//

import CoreData

enum StorageObjectError: LocalizedError {
    case serialisationFailed
}

public protocol StorageObject: Codable, Identifiable, Equatable, Sendable {
    var id: String { get }
    func toDictionary() throws -> [String: Any]
}
