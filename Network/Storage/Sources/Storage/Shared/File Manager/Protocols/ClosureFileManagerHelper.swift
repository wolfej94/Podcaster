//
//  ClosureFileManagerHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import Foundation

internal protocol ClosureFileManagerHelper {

    func downloadFile(at networkURL: URL?, session: NetworkURLSession, completionHandler: @escaping @Sendable (Result<URL, Error>) -> Void)

}
