//
//  ModelsViewModel.swift
//  ARFurniture
//
//  Created by MANAS VIJAYWARGIYA on 04/01/22.
//

import Foundation
import FirebaseFirestore

class ModelsViewModel: ObservableObject {
    @Published var models: [Model] = []
    
    private let db = Firestore.firestore()
    
    func fetchData() {
        // fetch data from firestore realtime
        db.collection("models").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Firestore: No documents returned")
                return
            }
            self.models = documents.map { (queryDocumentSnapshot) -> Model in
                let data = queryDocumentSnapshot.data()
                
                let name = data["name"] as? String ?? ""
                let categoryText = data["category"] as? String ?? ""
                let category = ModelCategory(rawValue: categoryText) ?? .decor
                let scaleCompensation = data["scaleCompensation"] as? Double ?? 1.0
                
                return Model(name: name, category: category, scaleCompensation: Float(scaleCompensation))
            }
        }
    }
}
