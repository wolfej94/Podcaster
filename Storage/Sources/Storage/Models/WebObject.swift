//
//  WebObject.swift
//  Storage
//
//  Created by James Wolfe on 02/12/2024.
//

import CoreData

public protocol WebObject: Identifiable, Equatable, Sendable {
    var id: Int64 { get }
}

extension WebObject {
    func toDictionary() -> [String: Any] {
        let mirror = Mirror(reflecting: self)
        return mirror.children
            .reduce(into: [String: Any](), {
                guard let label = $1.label else { return }
                $0[label] = $1.value
            })
    }
}
