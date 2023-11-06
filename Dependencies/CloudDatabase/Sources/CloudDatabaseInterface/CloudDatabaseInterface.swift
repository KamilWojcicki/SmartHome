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

public protocol Storable: Identifiable, Codable, Equatable {
    associatedtype DAO: DAOInterface
    
    init(from: DAO)
}

public protocol Reference {
    static var collection: String { get }
    var docRef: String? { get set }
}

public protocol CloudDatabaseManagerInterface {
    func createInMainCollection<Object: Storable>(object: Object) throws
    
    func createInSubCollection<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, object: Object) throws
    
    func readInMainCollection<Object: Storable>(_ documentID: String) async throws -> Object
    func readInSubCollection<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, documentID: String) async throws -> Object
    func readAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, objectsOfType type: Object.Type) async throws -> [Object]
    
    func updateInMainCollection<Object: Storable>(object: Object, data: [String: Any]) async throws
    func updateInSubCollection<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, object: Object, data: [String: Any]) async throws
    
    func delete<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, object: Object) async throws
    
    func handleObjectExist<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, object: Object) async throws -> Bool
}

public enum CloudDatabaseError: Error {
    case unableToSave
    case unableToFind
    case unableToUpdate
    case unableToDelete
    
    public var errorDescription: String? {
        switch self {
        case .unableToSave:
            return "There was a problem with saving data"
        case .unableToFind:
            return "There was a problem with finding data"
        case .unableToUpdate:
            return "There was a problem with updating data"
        case .unableToDelete:
            return "There was a problem with deleting data"
        }
    }
}
