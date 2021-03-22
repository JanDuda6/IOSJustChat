//
//  Constant.swift
//  IOSChat
//
//  Created by Kurs on 04/02/2021.
//

import Foundation

struct Constant {
    struct DBCategories {
        static let userImageFolder = "usersImagesAvatars"
        static let userImage = "userImage.jpg"
        static let userCollection = "users"
        static let roomsCollection = "rooms"
        static let contactsCollection = "contacts"
        static let userContactsCollection = "userContacts"
        static let messageCollection = "message"
    }

    struct ErrorDescription {
        static let DBDataError = "Error with retrieving data"
        static let DBUpdateError = "Error with updating data"
        static let DBSaveError = "Error with saving data user"
        static let LogOutError = "Error signing out"
        static let LogInError = "Error with log in with FaceBook" 
    }

    struct SystemImagesNames {
        static let originUserImage = "person.circle.fill"
        static let newMessageBubble = "exclamationmark.bubble.fill"
    }

    struct AlertMessages {
        static let DBDataUpdated = "You have successfully updated your data"
        static let addContactSuccessful = "You have added contact to list"
        static let userDoesNotExist = "User doesn't exist"
        static let shouldNotAddOwnEmail = "You can't add yours email to contact list"
        static let error = "Error"
        static let ok = "OK"
        static let success = "SUCCESS"
        static let emptyName = "Name can't be empty"
        static let emptyEmail = "Email can't be empty"
        static let deletePhoto = "Delete photo"
        static let takePhoto = "Take a photo"
        static let choosePhoto = "Choose a photo"
        static let cancel = "Cancel"
    }

    struct SegueIdentifier {
        static let loggedVC = "LoggedUserVC"
        static let chatVC = "chatViewSegue"
        static let newChatWindow = "showNewChatWindow"
        static let contactDetailsVC = "contactDetails"
        static let addContactVC = "showAddContactVC"
        static let chatSegue = "chatSegue"
        static let addContactSegue = "addContactSegue"
    }

    struct CellNamesAndIdentifier {
        static let chatListCell = "ChatListCell"
        static let chatListCellIdentifier = "chatListCell"
        static let contactCell = "ContactCell"
        static let contactCellIdentifier = "contactCell"
        static let userMessageCell = "UserMessageCell"
        static let recipientMessageCell = "RecipientMessageCell"
        static let userImageMessageCell = "UserImageMessageCell"
        static let recipientImageMessageCell = "RecipientImageMessageCell"
        static let userMessageCellIdentifier = "userMessageCell"
        static let recipientMessageCellIdentifier = "recipientMessageCell"
        static let userImageMessageCellIdentifier = "userImageMessageCell"
        static let recipientImageMessageCellIdentifier = "recipientImageMessageCell"
    }
    struct CustomElements {
        static let dateFormat = "HH:mm:ss E, d MMM y"
        static let buttonFont = "Helvetica Neue"
        static let googleButton = "Google"
        static let createAccountButton = "Create Account"
        static let logInButton = "Log In"
    }
}
