//
//  ARFurnitureApp.swift
//  ARFurniture
//
//  Created by MANAS VIJAYWARGIYA on 29/12/21.
//

import SwiftUI
import Firebase

@main
struct ARFurnitureApp: App {
    @StateObject var placementSetting = PlacementSetting()
    @StateObject var sessionSettings = SessionSettings()
    
    init() {
        FirebaseApp.configure()
        
        // Annonymous Authentication code with Firebase
        Auth.auth().signInAnonymously { authResult, error in
            guard let user = authResult?.user else {
                print("FAILED: Annonymous Authentication with Firebase")
                return
            }
            let uid = user.uid
            print("Firebase: Annonymous User Authentication with uid: \(uid).")
        }
        
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(placementSetting)
                .environmentObject(sessionSettings)
        }
    }
}
