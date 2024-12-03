//
//  StorageError.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

public enum StorageError: Error {
    case objectNotFound(String)
    case unexpected(Error)
    case missingURL
    case downloadFailed
}
