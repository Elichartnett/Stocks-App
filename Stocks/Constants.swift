//
//  Constants.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/23/21.
//

import Foundation
import SwiftUI

struct Constants {
    static var FavoritesView = "FavoritesView"
    static var SettingsView = "SettingsView"
    
    static var backgroundColor = LinearGradient(colors: [Color("customDarkBlue"), Color("customLightBlue")], startPoint: .topLeading, endPoint: .bottomTrailing)
}

enum Errors: Error {
    case connectionError
    case urlError
    case urlSessionError
    case managedObjectContextError
    case decodingError
}
