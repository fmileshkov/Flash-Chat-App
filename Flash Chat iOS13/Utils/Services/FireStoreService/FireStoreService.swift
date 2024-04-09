//
//  FireStoreMenager.swift
//  Flash Chat iOS13
//
//  Created by Admin on 6.06.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FireStoreService: FireStoreServiceProtocol {
    
    //MARK: - Properties
    static let shared = FireStoreService()
    private let firebaseAuth = Auth.auth()
    private let db = Firestore.firestore()
    private var messages: [Message] = []
    
    
    // MARK: - Initialiser
    private init() {
    }
    
    //MARK: - FireStoreServiceProtocol
    func getCurrentUser() -> String? {
        guard let currentUser = firebaseAuth.currentUser?.email else { return nil }
        
        return currentUser
    }
    
    func registerNewUser(_ email: String, _ password: String, _ completion: @escaping (String?, Error?) -> Void) {
        firebaseAuth.createUser(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else {
                return completion(nil, error)
            }
            
            completion(result?.user.uid,nil)
        }
    }
    
    func signIn(_ email: String, _ password: String, _ completion: @escaping (String?, Error?) -> Void) {
        firebaseAuth.signIn(withEmail: email, password: password) { [weak self] authData, error in
            guard error == nil else {
                return completion(nil, error)
            }
            
            completion(authData?.user.email, nil)
        }
    }
    
    func sendNewMessage(messageBody: String, _ completion: @escaping (Bool) -> Void) {
        guard let messageSender = firebaseAuth.currentUser?.email else { return }
        
        db.collection(Constants.FStore.collectionName).addDocument(data: [
            Constants.FStore.senderField: messageSender,
            Constants.FStore.bodyField: messageBody,
            Constants.FStore.dateField: Date().timeIntervalSince1970
        ]) { error in
            guard error != nil else { return }
            
            completion(false)
        }
    }
    
    func loadMessages(_ completion: @escaping (Bool, [Message]) -> Void) {
        db.collection(Constants.FStore.collectionName)
            .order(by: Constants.FStore.dateField)
            .addSnapshotListener { [weak self] querySnapshot, error in
                guard let self,
                      self.firebaseAuth.currentUser != nil else { return }
                
                var isMessageSended: Bool = false
                if error != nil {
                    isMessageSended = false
                } else {
                    guard let snapDocs = querySnapshot?.documents else {
                        isMessageSended = false
                        return
                    }
                    
                    for doc in snapDocs {
                        let data = doc.data()
                        guard let messageSender = data[Constants.FStore.senderField] as? String,
                              let messageBody = data[Constants.FStore.bodyField] as? String else {
                            return
                        }
                        if messageBody != Constants.blankString {
                            isMessageSended = true
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                        } else {
                            isMessageSended = false
                        }
                    }
                }
                completion(isMessageSended, self.messages)
            }
    }
    
    func getMessageDetails(_ atIndex: Int) -> (sender: Bool, messageText: String)? {
        guard let user =  getCurrentUser() else { return nil}
       
        let isSender = messages[atIndex].sender == user
        let body = messages[atIndex].body
        
        return isSender ? (true, body) : (false, body)
    }
    
    func logOutUser(_ completion: (Bool) -> Void) {
        do {
            try firebaseAuth.signOut()
            completion(true)
            messages = []
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            completion(false)
        }
    }
    
}
