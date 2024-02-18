//
//  AuthManager.swift
//  InstagramClone
//
//  Created by Rakesh Sharma on 18/02/24.
//  Copyright © 2024 Mac Gallagher. All rights reserved.
//

import Foundation
import Firebase
import FirebaseSharedSwift
import FirebaseStorage
import FirebaseFirestore
import FirebaseFirestoreInternal

class AuthManager{
    
    static let shared = AuthManager()
    var posts: [Post] = []

    
    func checkIfUserExist(phoneNumber: String, completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users") // Assuming "users" is the collection name
        
        // Query the collection for the user with the matching phone number
        let query = usersCollection.whereField("mobile", isEqualTo: phoneNumber)
        
        // Execute the query
        query.getDocuments { snapshot, error in
            if let error = error {
                // Error occurred while fetching user
                completion(nil, error)
            } else if let snapshot = snapshot, !snapshot.documents.isEmpty {
                // User found
                completion(snapshot.documents.first, nil)
            } else {
                // No user found with the provided phone number
                completion(nil, nil)
            }
        }
    }
    
    
    func uploadUser(withUID uid: String, username: String, mobile: String, completion: @escaping (Bool) -> ()) {
        var dictionaryValues = ["username": username]
        dictionaryValues["mobile"] = mobile
        let values = [uid: dictionaryValues]
        let db = Firestore.firestore()
        let postRef = db.collection("users").document()
        postRef.setData(values) { error in
            if let error = error {
                print("Error saving post to Firestore: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
    
    func createPostInCollection(withImage selectedImages: [UIImage], caption: String){
        var imageURLs: [String] = []
        let storageRef = Storage.storage().reference()
        for image in selectedImages {
            let imageRef = storageRef.child("images/\(UUID().uuidString).jpg")
            if let imageData = image.jpegData(compressionQuality: 0.5) {
                imageRef.putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                    } else {
                        imageRef.downloadURL { (url, error) in
                            if let imageURL = url {
                                imageURLs.append(imageURL.absoluteString)
                                if imageURLs.count == selectedImages.count {
                                    // All images uploaded, save post to Firestore
                                    self.savePostToFirestore(imageURLs: imageURLs, caption: caption)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func savePostToFirestore(imageURLs: [String], caption: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("Error: User not authenticated")
            return
        }
        let userName = Auth.auth().currentUser?.displayName ?? ""
        let db = Firestore.firestore()
        let postRef = db.collection("posts").document()
        let postData: [String: Any] = [
            "imageUrls": imageURLs,
            "postCreationDate": Date(),
            "userId": currentUserID,
            "postDescription": caption,
            "userName": userName
        ]
        postRef.setData(postData) { error in
            if let error = error {
                print("Error saving post to Firestore: \(error.localizedDescription)")
            } else {
                print("Post saved successfully")
                NotificationCenter.default.post(name: NSNotification.Name.updateHomeFeed, object: nil)
                // Dismiss the post creation view controller
            }
        }
    }
    
}
