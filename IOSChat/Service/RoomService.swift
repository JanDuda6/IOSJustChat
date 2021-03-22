//
//  RoomService.swift
//  IOSChat
//
//  Created by Kurs on 08/01/2021.
//

import Foundation
import Firebase

class RoomService {
    let db = Firestore.firestore()
    let contactService = ContactService()

    func createNewChatRoom(with contactUserID: String) {
        let date = Date()
        let documentID = db.collection(Constant.DBCategories.roomsCollection).document().documentID
        if let currentUserID = Auth.auth().currentUser?.uid {
            let currentUserEmail = Auth.auth().currentUser!.email

            let roomMembers = [contactUserID : true, currentUserID : true]
            let room = Room(createDate: date, members: roomMembers)
            db.collection(Constant.DBCategories.roomsCollection).document(documentID).setData(room.toDictionary())

            contactService.searchForUserInContactList(contactUserID: contactUserID) { (user) in
                let roomDetails = RoomDetails(userName: user!.name, userEmail: user!.email, userID: user!.userID)
                self.db.collection(Constant.DBCategories.userCollection).document(currentUserID).collection(Constant.DBCategories.roomsCollection).document(documentID).setData(roomDetails.toDictionary())
            }

            let roomDetails = RoomDetails(userName: "", userEmail: currentUserEmail!, userID: currentUserID)
            db.collection(Constant.DBCategories.userCollection).document(contactUserID).collection(Constant.DBCategories.roomsCollection).document(documentID).setData(roomDetails.toDictionary())
            changeUserNameInRoom(contactUserId: contactUserID, chatRoomID: documentID, currentUserEmail: currentUserEmail!)
        }
    }

    func checkIfRoomExists(with contactUserID: String) {
        searchForRoomID(contactUserID: contactUserID) { [self] (roomID) in
            if roomID == "" {
                createNewChatRoom(with: contactUserID)
            } 
        }
    }

    func loadUserRooms(completion: @escaping ([RoomDetails]) -> Void) {
        let currentUserID = Auth.auth().currentUser!.uid
        self.db.collection(Constant.DBCategories.userCollection)
            .document(currentUserID)
            .collection(Constant.DBCategories.roomsCollection)
            .addSnapshotListener { (querySnapshot, error) in
                var roomDetailsArray = [RoomDetails]()

                if let error = error {
                    print("\(Constant.ErrorDescription.DBDataError): \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let userID = data["uid"] as! String
                        let userEmail = data["email"] as! String
                        let userName = data["name"] as! String
                        let lastMessageBody = data["lastMessageBody"] as? String
                        let lastMessageSender = data["lastMessageSender"] as? String
                        let lastMessageCreateDate = data["lastMessageCreateDate"] as? Timestamp
                        let roomID = document.documentID
                        let lastMessageRead = data["lastMessageRead"] as? Bool

                        var roomDetails = RoomDetails(userName: userName, userEmail: userEmail, userID: userID)
                        roomDetails.roomID = roomID
                        roomDetails.lastMessageBody = lastMessageBody ?? ""
                        roomDetails.lastMessageSender = lastMessageSender ?? ""
                        roomDetails.lastMessageCreateDate = lastMessageCreateDate?.dateValue() ?? Date()
                        roomDetails.lastMessageRead = lastMessageRead ?? true

                        if lastMessageBody != nil {
                            roomDetailsArray.append(roomDetails)
                        }
                    }
                    roomDetailsArray.sort {
                        $0.lastMessageCreateDate > $1.lastMessageCreateDate
                    }
                    completion(roomDetailsArray)
                }
            }
    }

    func changeUserNameInRoom(contactUserId: String, chatRoomID: String, currentUserEmail: String) {
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection(Constant.DBCategories.contactsCollection)
            .document(contactUserId)
            .collection(Constant.DBCategories.userContactsCollection)
            .document(currentUserID)
            .getDocument { (querySnapshot, error) in

                if let e = error {
                    print("\(Constant.ErrorDescription.DBDataError): \(e.localizedDescription)")
                } else {
                    var userName = ""
                    let data = querySnapshot!.data()
                    if let name = data?["name"] {
                        userName = name as! String
                    } else {
                        userName = currentUserEmail
                    }
                    self.db.collection(Constant.DBCategories.userCollection)
                        .document(contactUserId)
                        .collection(Constant.DBCategories.roomsCollection)
                        .document(chatRoomID)
                        .updateData(["name" : userName])
                }
            }
    }

    func searchForRoomID(contactUserID: String, completion: @escaping (String) -> Void) {
        let currentUserID = Auth.auth().currentUser!.uid

        db.collection(Constant.DBCategories.roomsCollection)
            .whereField("members.\(contactUserID)", isEqualTo: true)
            .whereField("members.\(currentUserID)", isEqualTo: true)
            .getDocuments { (querySnapshot, error) in
                var roomID = ""
                if let error = error {
                    print("\(Constant.ErrorDescription.DBDataError): \(error.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        roomID = document.documentID
                    }
                }
                completion(roomID)
            }
    }
}
