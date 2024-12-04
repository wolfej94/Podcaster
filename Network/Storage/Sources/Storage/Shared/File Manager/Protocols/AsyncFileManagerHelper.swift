//
//  AsyncFileManagerHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import Foundation

internal protocol AsyncFileManagerHelper {

    func downloadFile(at networkURL: URL?, session: NetworkURLSession) async throws -> URL

}
