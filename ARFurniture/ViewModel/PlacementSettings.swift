//
//  PlacementSettings.swift
//  ARFurniture
//
//  Created by MANAS VIJAYWARGIYA on 31/12/21.
//

import SwiftUI
import RealityKit
import Combine

class PlacementSetting: ObservableObject {
    // When the user selects a model in Browse View, this property is set.
    @Published var selectedModel: Model? {
        willSet(newValue) {
            print("Setting selected Model to \(String(describing: newValue?.name))")
        }
    }
    
    // When the user taps confirms in PlacementView, the value of selectedModel is asigned to confirmedModel
    @Published var confirmedModel: Model? {
        willSet(newValue) {
            guard let model = newValue else {
                print("Clearing Confirmed Model")
                return
            }
            print("Setting Confirmed Model: \(model.name)")
            
            self.recentlyPlaced.append(model)
        }
    }
    
    // This property retains a record of placed models in the scene. The last element in an array is the most recently placed model.
    @Published var recentlyPlaced: [Model] = []
    
    
    // This property retains the cancellable object for our SceneEvents.Update subscriber
    var sceneObserver: Cancellable?
    
}

