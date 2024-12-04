//
//  SynchronousCoreDataHelper.swift
//  Storage
//
//  Created by James Wolfe on 03/12/2024.
//

import CoreData

internal protocol SynchronousCoreDataHelper {

    func fetchObjectIDs<T: NSManagedObject>(ofType type: T.Type,
                                            for ids: [String],
                                            in context: NSManagedObjectContext) throws -> [NSManagedObjectID]

    func fetchManagedObject<T: NSManagedObject>(ofType type: T.Type,
                                                byID id: String,
                                                in context: NSManagedObjectContext) throws -> T?

    func fetchManagedObjects<T: NSManagedObject>(ofType type: T.Type,
                                                 byIDs ids: [String]?,
                                                 in context: NSManagedObjectContext) throws -> [T]

}
