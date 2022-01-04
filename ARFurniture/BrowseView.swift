//
//  BrowseView.swift
//  ARFurniture
//
//  Created by MANAS VIJAYWARGIYA on 30/12/21.
//

import SwiftUI

struct BrowseView: View {
//    @Environment(\.dismiss) var dismissMode
    @Binding var showBrowse: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false){
                RecentsGrid(showBrowse: $showBrowse)
                ModelsByCategoryGrid(showBrowse: $showBrowse)
            }
            .navigationBarTitle(Text("Browse"), displayMode: .large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
//                       dismissMode()
                        self.showBrowse = false
                    }) {
                        Text("Done").bold()
                    }
                }
            }
        }
    }
}

struct RecentsGrid: View {
    @EnvironmentObject var placementSettings: PlacementSetting
    @Binding var showBrowse: Bool
    
    var body: some View {
        if !self.placementSettings.recentlyPlaced.isEmpty {
            HorizontalGrid(showBrowse: $showBrowse, title: "Recents", items: getRecentsUniqueOrder())
        }
    }
    
    func getRecentsUniqueOrder() -> [Model] {
        var recentsUniqueOrderArray: [Model] = []
        var modelNameSet: Set<String> = []
        
        for model in self.placementSettings.recentlyPlaced.reversed() {
            if !modelNameSet.contains(model.name) {
                recentsUniqueOrderArray.append(model)
                modelNameSet.insert(model.name)
            }
        }
        return recentsUniqueOrderArray
    }
}


struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        BrowseView(showBrowse: .constant(false))
    }
}
