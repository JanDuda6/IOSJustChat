//
//  ContactService.swift
//  IOSChat
//
//  Created by Kurs on 08/01/2021.
//

import Foundation
import Firebase
import FirebaseStorage

class ContactService {
    let db = Firestore.firestore()
    let userService = UserService()
    
    func searchForUserInContactList(contactUserID: String, completion: @escaping (User?) -> Void) {
        let currentUser = Auth.auth().currentUser!.uid
        db.collection(Constant.DBCategories.contactsCollection)
            .document(currentUser)
            .collection(Constant.DBCategories.userContactsCollection)
            .document(contactUserID)
            .getDocument { (querySnapshot, error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBDataError): \(error.localizedDescription)")
                } else {
                    if let data = querySnapshot?.data() {
                        let name = data["name"] as! String
                        let email = data["email"] as! String
                        let userID = data["uid"] as! String
                        let user = User(email: email, name: name, userID: userID)
                        completion(user)
                    }
                }
            }
    }
    
    func addFriendToContactList(contactEmail: String, contactName: String, viewController: UIViewController) {
        let trimmedEmail = contactEmail.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let currentUserEmail = Auth.auth().currentUser!.email
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection(Constant.DBCategories.userCollection)
            .whereField("email", isEqualTo: trimmedEmail)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBDataError) \(error.localizedDescription)")
                } else {
                    if querySnapshot?.documents.count == 0 {
                        AlertHandler.errorHandler(view: viewController, errorMessage: Constant.AlertMessages.userDoesNotExist)
                        return
                    }
                    if contactEmail == currentUserEmail! {
                        AlertHandler.errorHandler(view: viewController, errorMessage: Constant.AlertMessages.shouldNotAddOwnEmail)
                        return
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            let userID = data["uid"] as! String
                            let contactEmail = data["email"] as! String
                            let userContact = User(email: contactEmail, name: contactName, userID: userID)
                            self.db.collection(Constant.DBCategories.contactsCollection)
                                .document(currentUserID)
                                .collection(Constant.DBCategories.userContactsCollection)
                                .document(document.documentID)
                                .setData(userContact.toDictionary())
                            self.db.collection(Constant.DBCategories.contactsCollection)
                                .document(currentUserID)
                                .setData(["uid" : currentUserID])
                        }
                    }
                }
                AlertHandler.updateSuccessHandler(view: viewController, message: Constant.AlertMessages.addContactSuccessful)
            }

        db.collection(Constant.DBCategories.userCollection)
            .document(currentUserID)
            .collection(Constant.DBCategories.roomsCollection)
            .whereField("email", isEqualTo: contactEmail)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBDataError) \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        let roomID = document.documentID
                        self.db.collection(Constant.DBCategories.userCollection)
                            .document(currentUserID)
                            .collection(Constant.DBCategories.roomsCollection)
                            .document(roomID)
                            .updateData(["name" : contactName])
                    }
                }
            }
    }
    
    func loadContactList(completion: @escaping ([User]) -> Void) {
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection(Constant.DBCategories.contactsCollection)
            .document(currentUserID)
            .collection(Constant.DBCategories.userContactsCollection)
            .addSnapshotListener { (querySnapshot, error) in
                var contactList = [User]()
                if let error = error {
                    print("\(Constant.ErrorDescription.DBDataError): \(error.localizedDescription)")
                } else {
                    if let snapshotDocuments = querySnapshot?.documents {
                        for document in snapshotDocuments {
                            let data = document.data()
                            let uid = data["uid"] as! String
                            let name = data["name"] as! String
                            let email = data["email"] as! String
                            let contact = User(email: email, name: name, userID: uid)
                            contactList.append(contact)
                            contactList.sort {
                                $0.name < $1.name
                            }
                            completion(contactList)
                        }
                    }
                }
            }
    }
    
    func updateContactName(contactID: String, contactNewName: String) {
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection(Constant.DBCategories.contactsCollection)
            .document(currentUserID)
            .collection(Constant.DBCategories.userContactsCollection)
            .document(contactID)
            .updateData(["name" : contactNewName])

        db.collection(Constant.DBCategories.userCollection)
            .document(currentUserID)
            .collection(Constant.DBCategories.roomsCollection)
            .whereField("uid", isEqualTo: contactID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBUpdateError): \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        let roomID = document.documentID
                        self.db.collection(Constant.DBCategories.userCollection)
                            .document(currentUserID)
                            .collection(Constant.DBCategories.roomsCollection)
                            .document(roomID)
                            .updateData(["name" : contactNewName])
                    }
                }
            }
    }
}
