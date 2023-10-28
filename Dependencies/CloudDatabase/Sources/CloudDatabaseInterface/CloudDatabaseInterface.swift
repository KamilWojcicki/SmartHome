//  CloudDatabaseInterface.swift
//  
//
//  Created by Kamil Wójcicki on 27/10/2023.
//

import Foundation

public protocol DAOInterface: Identifiable, Codable, Equatable, Reference {
    associatedtype Model: Storable
    
    init(from: Model)
}

public protocol Storable: Identifiable, Codable, Equatable, Reference {
    associatedtype DAO: DAOInterface
    
    init(from: DAO)
}

public protocol Reference {
    static var collection: String { get }
    var docRef: String? { get set }
}

public protocol CloudDatabaseManagerInterface {
    func create<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) throws
    func read<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) async throws -> Object
    func readAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object]
}
