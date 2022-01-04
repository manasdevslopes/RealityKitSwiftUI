//
//  HorizontalGrid.swift
//  ARFurniture
//
//  Created by MANAS VIJAYWARGIYA on 31/12/21.
//

import SwiftUI

struct ModelsByCategoryGrid: View {
    @Binding var showBrowse: Bool
//    let models = Models()
    
    @ObservedObject private var viewModel = ModelsViewModel()
    
    var body: some View {
        VStack {
            ForEach(ModelCategory.allCases, id: \.self) { category in
                if let modelsByCategory = viewModel.models.filter({ $0.category == category }) {
                    HorizontalGrid(showBrowse: $showBrowse,title: category.label, items: modelsByCategory)
                }
            }
        }
        .onAppear() {
            self.viewModel.fetchData()
        }
    }
}

struct HorizontalGrid: View {
    @EnvironmentObject var placementSettings: PlacementSetting
    @Binding var showBrowse: Bool
    private let gridItemLayout = [GridItem(.fixed(150))]
    var title: String
    var items: [Model]
    
    var body: some View {
        VStack(alignment: .leading) {
            Seperator()
            
            Text(title)
                .font(.title2).bold()
                .padding(.leading, 22)
                .padding(.top, 10)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: gridItemLayout, spacing: 30) {
                    ForEach(0..<items.count, id: \.self) {index in
                        let model = items[index]
                        
                        ItemButton(model: model) {
                            model.asyncLoadModelEntity()
                            self.placementSettings.selectedModel = model
                            print("BrowseView: selected \(model.name) for placement")
                            self.showBrowse = false
                        }
                    }
                }
                .padding(.horizontal, 22)
                .padding(.vertical, 10)
            }
            
            
        }
    }
}

struct ItemButton: View {
    @ObservedObject var model: Model
    var action: ()->Void
    
    var body: some View {
        Button(action: {
            self.action()
        }) {
            Image(uiImage: self.model.thumbnail)
                .resizable()
                .frame(height: 150)
                .aspectRatio(1/1, contentMode: .fit)
                .background(Color(UIColor.secondarySystemFill))
                .cornerRadius(8)
        }
    }
}
struct Seperator: View {
    var body: some View {
        Divider()
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
    }
}

struct HorizontalGrid_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalGrid(showBrowse: .constant(false),title: "", items: [Model]())
            .environmentObject(PlacementSetting())
    }
}
