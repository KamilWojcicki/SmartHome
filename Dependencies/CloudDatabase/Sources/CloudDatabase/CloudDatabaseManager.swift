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
    
    private func collectionReference<ParentObject: Storable, Object: Storable>(
        parentObject: ParentObject? = nil,
        objectOfType type: Object.Type
    ) throws -> CollectionReference {
        
        if let parentObject = parentObject {
            let parentObjectDAO: ParentObject.DAO = DAOFactory.initializeDAO(from: parentObject)
            let parentObjectId = String(describing: parentObjectDAO.id)
            
            return database
                .collection(ParentObject.DAO.collection)
                .document(parentObjectId)
                .collection(Object.DAO.collection) //SubTask
        } else {
            return database
                .collection(Object.DAO.collection)
        }
    }
}

extension CloudDatabaseManager {
    //CREATE
    func createInMainCollection<Object: Storable>(object: Object) throws {
        let objectDAO: Object.DAO = DAOFactory.initializeDAO(from: object)
        let objectId = String(describing: objectDAO.id)
        
        do {
            try database
                .collection(Object.DAO.collection)
                .document(objectId)
                .setData(from: objectDAO)
        } catch {
            throw CloudDatabaseError.unableToSave
        }
    }
    
    func createInSubCollection<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, object: Object) throws {
        var objectDAO: Object.DAO = DAOFactory.initializeDAO(from: object)
        let objectId = String(describing: objectDAO.id)
        
        do {
            try collectionReference(parentObject: parentObject, objectOfType: Object.self)
                .document(objectId)
                .setData(from: objectDAO)
        } catch {
            throw CloudDatabaseError.unableToSave
        }
    }
    
    //READ
    func readInMainCollection<Object: Storable>(_ documentID: String) async throws -> Object {
        do {
            let objectDAO = try await database
                .collection(Object.DAO.collection)
                .document(documentID)
                .getDocument(as: Object.DAO.self)
            
            return DAOFactory.initializeObject(from: objectDAO)
        } catch {
            throw CloudDatabaseError.unableToFind
        }
    }
    
    func readInSubCollection<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, documentID: String) async throws -> Object {
        do {
            let objectDAO = try await collectionReference(parentObject: parentObject, objectOfType: Object.self)
                .document(documentID)
                .getDocument(as: Object.DAO.self)
            
            return DAOFactory.initializeObject(from: objectDAO)
        } catch {
            throw CloudDatabaseError.unableToFind
        }
    }
    
    func readAll<ParentObject: Storable, Object: Storable>(parentObject: ParentObject? = nil, objectsOfType type: Object.Type) async throws -> [Object] {
        let snapshot = try await collectionReference(parentObject: parentObject, objectOfType: type).getDocuments()
        
        return try snapshot
            .documents
            .compactMap { document in
                let objectDAO = try document.data(as: Object.DAO.self)
                
                return DAOFactory.initializeObject(from: objectDAO)
            }
    }
    
    //UPDATE
    func updateInMainCollection<Object: Storable>(object: Object, data: [String : Any]) async throws {
        let documentID = String(describing: object.id)
        
        do {
            try await database
                .collection(Object.DAO.collection)
                .document(documentID)
                .updateData(data)
        } catch {
            throw CloudDatabaseError.unableToUpdate
        }
    }
    
    func updateInSubCollection<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, object: Object, data: [String : Any]) async throws {
        let documentID = String(describing: object.id)
        
        do {
            try await collectionReference(parentObject: parentObject, objectOfType: Object.self)
                .document(documentID)
                .updateData(data)
        } catch {
            throw CloudDatabaseError.unableToUpdate
        }
    }
    
    //DELETE
    func delete<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, object: Object) async throws {
        let documentID = String(describing: object.id)
        
        do {
            try await collectionReference(parentObject: parentObject, objectOfType: Object.self)
                .document(documentID)
                .delete()
            
        } catch {
            throw CloudDatabaseError.unableToDelete
        }
    }
    
    func handleObjectExist<ParentObject: Storable, Object: Storable>(parentObject: ParentObject, object: Object) async throws -> Bool {
        let objectId = String(describing: object.id)
        let objectDocRef = try collectionReference(parentObject: parentObject, objectOfType: Object.self).document(objectId)
        
        do {
            let document = try await objectDocRef.getDocument()
            
            return document.exists ? false : true
        } catch {
            throw URLError(.badServerResponse)
        }
    }
}
