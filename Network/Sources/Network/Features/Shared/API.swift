//
//  API.swift
//  Network
//
//  Created by James Wolfe on 02/12/2024.
//

import Foundation

internal protocol API {
    var request: URLRequest { get }
}
