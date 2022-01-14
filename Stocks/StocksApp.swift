//
//  StocksApp.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/22/21.
//

import SwiftUI

@main
struct StocksApp: App {
    
    let dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(StockModel())
        }
    }
}
