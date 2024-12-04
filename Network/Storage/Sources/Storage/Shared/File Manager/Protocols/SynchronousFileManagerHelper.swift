//
//  SynchronousFileManagerHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import Foundation

internal protocol SynchronousFileManagerHelper {

    func cleanUpFiles(for episode: Episode) throws

}
