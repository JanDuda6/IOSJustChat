//
//  UserService.swift
//  IOSChat
//
//  Created by Kurs on 18/11/2020.
//

import UIKit
import Firebase
import FirebaseStorage

class UserService {
    let db = Firestore.firestore()
    let storage = Storage.storage().reference()

    func addUserToDB(userName: String, userEmail: String, userID: String) {
        let userImageRef = storage.child("/\(Constant.DBCategories.userImageFolder)/\(userID)/\(Constant.DBCategories.userImage)")
        let emptyData = Data()
        var displayName = ""
        displayName = userName != "" ? userName : substringToDisplayName(with: userEmail)
        let user = User(email: userEmail, name: displayName, userID: userID)
        db.collection(Constant.DBCategories.userCollection)
            .document(userID)
            .getDocument(completion: { (querySnapshot, _) in
                if querySnapshot?.data() == nil {
                    self.db.collection(Constant.DBCategories.userCollection)
                        .document(userID)
                        .setData(user.toDictionary())
                    userImageRef.putData(emptyData)
                }
            })
    }

    func setUserImage(userImage: UIImage) {
        let userID = Auth.auth().currentUser!.uid
        let userImageRef = storage.child("/\(Constant.DBCategories.userImageFolder)/\(userID)/\(Constant.DBCategories.userImage)")
        guard let data = userImage.jpegData(compressionQuality: 0.2) else {return}
        userImageRef.putData(data)
    }
    
    func loadUserImage(contactUserID: String, completion: @escaping (UIImage) -> Void) {
        let userID = Auth.auth().currentUser!.uid
        var userImageRef = self.storage.child("/\(Constant.DBCategories.userImageFolder)/\(userID)/\(Constant.DBCategories.userImage)")
        var image = UIImage()
        if contactUserID != "" {
            userImageRef = self.storage.child("/\(Constant.DBCategories.userImageFolder)/\(contactUserID)/\(Constant.DBCategories.userImage)")
        }
        userImageRef.getData(maxSize: 5 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("\(Constant.ErrorDescription.DBDataError): \(error.localizedDescription)")
            } else {
                if data?.count != 0 {
                    image = UIImage(data: data!)!
                } else {
                    image = UIImage(systemName: Constant.SystemImagesNames.originUserImage)!
                }
            }
            completion(image)
        }
    }

    func updateUserPassword(with password: String, viewController: UIViewController) {
        if password != "" {
            let currentUser = Auth.auth().currentUser
            currentUser?.updatePassword(to: password, completion: { (error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBUpdateError): \(error.localizedDescription)")
                    AlertHandler.errorHandler(view: viewController, error: error)
                } else {
                    AlertHandler.updateSuccessHandler(view: viewController, message: Constant.AlertMessages.DBDataUpdated)
                }
            })
        }
    }

    func updateUserEmail(with email: String, viewController: UIViewController) {
        if email != "" {
            let currentUser = Auth.auth().currentUser
            let currentUserID = currentUser!.uid

            // update email in authorization manager
            currentUser?.updateEmail(to: email, completion: { (error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBUpdateError): \(error.localizedDescription)")
                    AlertHandler.errorHandler(view: viewController, error: error)
                } else {

                    // update email in users collection
                    self.db.collection(Constant.DBCategories.userCollection).document(currentUserID).updateData(["email" : email])

                    // update email in contacts collection
                    self.db.collection(Constant.DBCategories.contactsCollection)
                        .getDocuments(completion: { (querySnapshot, error) in
                            if let error = error {
                                print("\(Constant.ErrorDescription.DBDataError): \(error.localizedDescription)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let documentID = document.documentID
                                    if documentID != currentUserID {
                                        self.db.collection(Constant.DBCategories.contactsCollection)
                                            .document(documentID)
                                            .collection(Constant.DBCategories.userContactsCollection)
                                            .whereField("uid", isEqualTo: currentUserID)
                                            .getDocuments { (querySnapshot, error) in
                                                if let error = error {
                                                    print("\(Constant.ErrorDescription.DBDataError): \(error.localizedDescription)")
                                                } else {
                                                    if querySnapshot!.documents.count > 0 {
                                                        self.db.collection(Constant.DBCategories.contactsCollection)
                                                            .document(documentID)
                                                            .collection(Constant.DBCategories.userContactsCollection)
                                                            .document(currentUserID)
                                                            .updateData(["email" : email])
                                                    }
                                                }
                                            }
                                    }
                                }
                            }
                        })

                    // update email in rooms
                    self.db.collection(Constant.DBCategories.roomsCollection)
                        .whereField("members.\(currentUserID)", isEqualTo: true)
                        .getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("\(Constant.ErrorDescription.DBUpdateError):\(error.localizedDescription)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let roomID = document.documentID
                                    let data = document.data()
                                    let map = data["members"] as! ([String : Bool])
                                    for contactUserID in map.keys {
                                        if contactUserID != currentUserID {
                                            self.db.collection(Constant.DBCategories.userCollection)
                                                .document(contactUserID)
                                                .collection(Constant.DBCategories.roomsCollection)
                                                .document(roomID)
                                                .updateData(["email" : email])
                                        }
                                    }
                                }
                            }
                        }
                    AlertHandler.updateSuccessHandler(view: viewController, message: Constant.AlertMessages.DBDataUpdated)
                }
            })
        }
    }

    func updateUserName(with name: String, viewController: UIViewController) {
        if name != "" {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = name
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    print("\(Constant.ErrorDescription.DBUpdateError): \(error.localizedDescription)")
                    AlertHandler.errorHandler(view: viewController, error: error)
                } else {
                    AlertHandler.updateSuccessHandler(view: viewController, message: Constant.AlertMessages.DBDataUpdated)                }
            })
        }
    }

    func substringToDisplayName(with email: String) -> String {
        let substringEmail = email.firstIndex(of: "@")
        let displayName = (email[..<substringEmail!])
        return String(displayName)
    }
}
