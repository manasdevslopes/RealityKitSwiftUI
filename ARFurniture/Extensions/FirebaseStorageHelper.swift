//
//  FirebaseStorageHelper.swift
//  ARFurniture
//
//  Created by MANAS VIJAYWARGIYA on 04/01/22.
//

import Foundation
import Firebase

class FirebaseStorageHelper {
    static private let cloudStorage = Storage.storage()
    
    class func asyncDownloadToFileSystem(relativePath: String, handler: @escaping (_ fileUrl: URL)->Void ) {
        // Create Local File System URL
        let docsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileUrl = docsUrl.appendingPathComponent(relativePath)
        
        // Check if the asset already in the file system
        // if it is then load the asset and return otherwise download the asset
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            handler(fileUrl)
            return
        }
        
        // Create a reference to the asset
        let storageRef = cloudStorage.reference(withPath: relativePath)
        // Download to the Local File System
        storageRef.write(toFile: fileUrl) {url, error in
            guard let localUrl = url else {
                print("Firebase Storage: Error downloading file with relative path : \(relativePath)")
                return
            }
            handler(localUrl)
        }.resume()
    }
}
