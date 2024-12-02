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

public protocol StorageObject: Encodable, Identifiable, Equatable, Sendable {
    var id: String { get }
    func toDictionary() throws -> [String: Any]
    associatedtype manageObjectType: NSManagedObject
    var managedObjectId: NSManagedObjectID? { get }
    init(from: manageObjectType)
}
