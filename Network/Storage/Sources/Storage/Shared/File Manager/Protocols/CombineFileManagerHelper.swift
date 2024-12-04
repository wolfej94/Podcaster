//
//  CombineFileManagerHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import Foundation
import Combine

internal protocol CombineFileManagerHelper {

    func downloadFilePublisher(at networkURL: URL?, session: NetworkURLSession) -> AnyPublisher<URL, Error>

}
