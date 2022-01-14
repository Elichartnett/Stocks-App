//
//  AddStockButton.swift
//  Stocks
//
//  Created by Eli Hartnett on 1/5/22.
//

import SwiftUI

struct AddStockButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        Image(systemName: "plus.circle")
            .foregroundColor(.black)
            .scaleEffect(configuration.isPressed ? 1.1 : 1)
    }
}
