//
//  DataController.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/28/21.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    
    static let shared = DataController()
    var container = NSPersistentContainer(name: "Stock Data Model")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
