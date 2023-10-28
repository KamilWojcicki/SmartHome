//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 27/10/2023.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import CloudDatabaseInterface

fileprivate struct DAOFactory {
    static func initializeObject<DAO: DAOInterface, Object: Storable>(from dao: DAO) -> Object {
        guard let dao = dao as? Object.DAO else {
            fatalError()
        }
        
        return Object(from: dao)
    }
    
    static func initializeDAO<Object: Storable, DAO: DAOInterface>(from object: Object) -> DAO {
        guard let object = object as? DAO.Model else {
            fatalError()
        }
        
        return DAO(from: object)
    }
}

final class CloudDatabaseManager: CloudDatabaseManagerInterface {
    
    private lazy var database = Firestore.firestore()
    
    private func collectionReference<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectOfType type: Object.Type) throws -> CollectionReference {
        
        // Get the collection name from the appropriate DAO
        let collection = Object.collection
        
        if let parentObject = parentObject {
            
            // If a parent object exists, retrieve its docRef
            // - protocol Reference
            
            guard let docRef = parentObject.docRef else {
                throw URLError(.badURL)
            }
            
            // Create and return a CollectionReference with the parent object
            return database
                .document(docRef) //Users/userId/Tasks/taskId
                .collection(collection) //SubTask
        } else {
            // Create and return a CollectionReference without a parent object
            return database
                .collection(collection) //Users
        }
    }
}

extension CloudDatabaseManager {
    func create<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, object: Object) throws {
        var objectDAO: Object.DAO = DAOFactory.initializeDAO(from: object)
        let objectId = String(describing: object.id)
        
        objectDAO.docRef = try collectionReference(parentObject: parentObject, objectOfType: Object.self).document(objectId).path
        
        try database
            .document(objectDAO.docRef ?? "Unknown")
            .setData(from: objectDAO)
    }
    
    func read<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, object: Object) async throws -> Object {
        let documentId = String(describing: object.id)
        
        let objectDAO = try await collectionReference(parentObject: parentObject, objectOfType: Object.self)
            .document(documentId)
            .getDocument(as: Object.DAO.self)
        
        return DAOFactory.initializeObject(from: objectDAO)
    }
    
    func readAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject?, objectsOfType type: Object.Type) async throws -> [Object] {
        let snapshot = try await collectionReference(parentObject: parentObject, objectOfType: type).getDocuments()
        
        return try snapshot
            .documents
            .compactMap { document in
                let objectDAO = try document.data(as: Object.DAO.self)
                
                return DAOFactory.initializeObject(from: objectDAO)
            }
    }
}
