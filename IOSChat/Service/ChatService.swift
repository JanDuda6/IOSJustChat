//
//  ChatService.swift
//  IOSChat
//
//  Created by Kurs on 05/01/2021.
//

import Foundation
import Firebase

class ChatService {
    let db = Firestore.firestore()
    let roomService = RoomService()
    let storage = Storage.storage()

    func loadMessages(roomID: String, completion: @escaping ([Message]) -> Void) {
        db.collection(Constant.DBCategories.roomsCollection)
            .document(roomID)
            .collection(Constant.DBCategories.messageCollection)
            .order(by: "date")
            .addSnapshotListener { (querySnapshot, error) in
                var messages = [Message]()
                if let e = error {
                    print("\(Constant.ErrorDescription.DBDataError): \(e.localizedDescription)")
                } else {
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        let sender = data["sender"] as! String
                        let senderID = data["senderID"] as! String
                        let body = data["body"] as! String
                        let date = data["date"] as! Timestamp
                        let imageURL = data["imageURL"] as! String
                        let imageMessage = data["imageMessage"] as! Bool
                        var message = Message(sender: sender, senderID: senderID, body: body, date: date.dateValue(), imageMessage: imageMessage)
                        message.imageURL = imageURL
                        messages.append(message)
                    }
                }
                completion(messages)
            }
    }

    func sendMessage(messageBody: String, roomID: String, contactUserID: String, imageMessage: Bool, imageToSend: UIImage?) {
        let trimmedMessage = messageBody.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedMessage == "" && imageMessage == false {
            return
        }
        let date = Date()
        let currentUserEmail = Auth.auth().currentUser!.email
        let currentUserId = Auth.auth().currentUser!.uid

        if imageMessage == true {
            var message = Message(sender: currentUserEmail!, senderID: currentUserId, body: messageBody, date: date, imageMessage: true)
            let imageUUID = UUID().uuidString
            let imageRef = storage.reference().child("\(Constant.DBCategories.roomsCollection)/\(roomID)/\(imageUUID).jpg")
            guard let data = imageToSend!.jpegData(compressionQuality: 0.1) else {return}
            let uploadImage = imageRef.putData(data)
            uploadImage.observe(.success) { snapshot in
                imageRef.downloadURL { [self] (url, error) in
                    message.imageURL = url!.absoluteString
                    addMessageToCollectionAndSaveLastMessage(roomID: roomID, message: message, contactUserID: contactUserID, currentUserID: currentUserId)
                }
            }
        } else {
            let message = Message(sender: currentUserEmail!, senderID: currentUserId, body: messageBody, date: date, imageMessage: false)
            addMessageToCollectionAndSaveLastMessage(roomID: roomID, message: message, contactUserID: contactUserID, currentUserID: currentUserId)
        }
    }

    func addMessageToCollectionAndSaveLastMessage(roomID: String, message: Message, contactUserID: String, currentUserID: String) {
        db.collection(Constant.DBCategories.roomsCollection)
            .document(roomID)
            .collection(Constant.DBCategories.messageCollection)
            .addDocument(data: message.toDictionary())
        saveLastMessageInRoomDetails(contactUserID: contactUserID, currentUserID: currentUserID)
    }

    func saveLastMessageInRoomDetails(contactUserID: String, currentUserID: String) {
        roomService.searchForRoomID(contactUserID: contactUserID) { [self] (roomID) in
            db.collection(Constant.DBCategories.roomsCollection)
                .document(roomID)
                .collection(Constant.DBCategories.messageCollection)
                .order(by: "date", descending: true)
                .limit(to: 1)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("\(Constant.ErrorDescription.DBDataError): \(error.localizedDescription)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            let lastMessageBody = data["body"] as! String
                            let lastMessageSender = data["sender"] as! String
                            let lastMessageCreateDate = data["date"] as! Timestamp

                            db.collection(Constant.DBCategories.userCollection)
                                .document(currentUserID)
                                .collection(Constant.DBCategories.roomsCollection)
                                .document(roomID)
                                .updateData([
                                                "lastMessageBody" : lastMessageBody,
                                                "lastMessageSender" : lastMessageSender,
                                                "lastMessageCreateDate" : lastMessageCreateDate])

                            db.collection(Constant.DBCategories.userCollection)
                                .document(contactUserID)
                                .collection(Constant.DBCategories.roomsCollection)
                                .document(roomID)
                                .updateData([
                                                "lastMessageBody" : lastMessageBody,
                                                "lastMessageSender" : lastMessageSender,
                                                "lastMessageCreateDate" : lastMessageCreateDate,
                                                "lastMessageRead" : false])
                        }
                    }
                }
        }
    }

    func readAndUpdateLastMessage(roomID: String) {
        let currentUserID = Auth.auth().currentUser!.uid
        db.collection(Constant.DBCategories.userCollection)
            .document(currentUserID)
            .collection(Constant.DBCategories.roomsCollection)
            .document(roomID)
            .updateData(["lastMessageRead" : true])
    }
}

