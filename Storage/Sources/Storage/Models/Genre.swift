//
//  Genre.swift
//  Storage
//
//  Created by James Wolfe on 02/12/2024.
//

public struct Genre: Encodable, Identifiable, Equatable, Sendable {
    public let id: Int

    internal init(id: Int) {
        self.id = id
    }
}
