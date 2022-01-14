//
//  Stock+CoreDataProperties.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/31/21.
//
//

import Foundation
import CoreData


extension Stock {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Stock> {
        return NSFetchRequest<Stock>(entityName: "Stock")
    }

    @NSManaged public var avgVolume: Int
    @NSManaged public var change: Double
    @NSManaged public var changesPercentage: Double
    @NSManaged public var dayHigh: Double
    @NSManaged public var dayLow: Double
    @NSManaged public var earningsAnnouncement: String
    @NSManaged public var eps: Double
    @NSManaged public var exchange: String
    @NSManaged public var historicalPrices: [Double]
    @NSManaged public var id: UUID
    @NSManaged public var isFavorite: Bool
    @NSManaged public var marketCap: Double
    @NSManaged public var name: String
    @NSManaged public var open: Double
    @NSManaged public var pe: Double
    @NSManaged public var previousClose: Double
    @NSManaged public var price: Double
    @NSManaged public var priceAvg50: Double
    @NSManaged public var priceAvg200: Double
    @NSManaged public var sharesOutStanding: Int
    @NSManaged public var ticker: String
    @NSManaged public var timestamp: Int
    @NSManaged public var volume: Int
    @NSManaged public var yearHigh: Double
    @NSManaged public var yearLow: Double
    @NSManaged public var lastRefresh: Date

}

extension Stock : Identifiable {

}
