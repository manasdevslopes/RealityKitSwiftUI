//
//  View+Extensions.swift
//  ARFurniture
//
//  Created by MANAS VIJAYWARGIYA on 03/01/22.
//

import SwiftUI

extension View {
    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
}
