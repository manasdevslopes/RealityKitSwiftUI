//
//  Model.swift
//  ARFurniture
//
//  Created by MANAS VIJAYWARGIYA on 31/12/21.
//

import SwiftUI
import RealityKit
import Combine

enum ModelCategory: String, CaseIterable {
    case table, chair, decor, light

    var label: String {
        get {
            switch self {
            case .table:
                return "Table"
            case .chair:
                return "Chair"
            case .decor:
                return "Decor"
            case .light:
                return "Light"
            }
        }
    }
}

class Model: ObservableObject, Identifiable {
    var id: String = UUID().uuidString
    var name: String
    var category: ModelCategory
    @Published var thumbnail: UIImage
    var modelEntity: ModelEntity?
    var scaleCompensation: Float
    
    private var cancellable: AnyCancellable?
    
    init(name: String, category: ModelCategory, scaleCompensation: Float = 1.0) {
        self.name = name
        self.category = category
        self.thumbnail = UIImage(systemName: "photo")!
        self.scaleCompensation = scaleCompensation
        
        FirebaseStorageHelper.asyncDownloadToFileSystem(relativePath: "thumbnails/\(self.name).png") { localUrl in
            do {
                let imageData = try Data(contentsOf: localUrl)
                self.thumbnail = UIImage(data: imageData) ?? self.thumbnail
            } catch {
                print("Error loading image: \(error.localizedDescription)")
            }
        }
    }
    
    func asyncLoadModelEntity() {
        FirebaseStorageHelper.asyncDownloadToFileSystem(relativePath: "models/\(self.name).usdz") { localUrl in
            self.cancellable = ModelEntity.loadModelAsync(contentsOf: localUrl)
                .sink(receiveCompletion: {loadCompletion in
                    switch loadCompletion {
                    case .failure(let error): print("Unable to load model entity for \(self.name). Error: \(error.localizedDescription)")
                    case .finished:
                        break
                    }
                }, receiveValue: {modelEntity in
                    self.modelEntity = modelEntity
                    self.modelEntity?.scale *= self.scaleCompensation
                    print("ModelEntity for name \(self.name) has been loaded")
                })
        }
    }
}



//struct Models {
//    var all: [Model] = []
//
//    init() {
//        let diningChair = Model(name: "dining_chair", category: .chair, scaleCompensation: 0.6)
//        let diningCup = Model(name: "dining_cup", category: .table, scaleCompensation: 0.3)
//
//        let flowerVase = Model(name: "flower_vase", category: .decor, scaleCompensation: 0.4)
//        let gramophone = Model(name: "gramophone", category: .decor, scaleCompensation: 0.2)
//        let guitarStand = Model(name: "guitar_stand", category: .decor, scaleCompensation: 1)
//        let teaPot = Model(name: "tea_pot", category: .light, scaleCompensation: 0.4)
//
//        self.all += [diningChair, diningCup, flowerVase, gramophone, guitarStand, teaPot]
//    }
//
//    func get(category: ModelCategory) -> [Model] {
//        return all.filter { $0.category == category }
//    }
//}
