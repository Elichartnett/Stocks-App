//
//  Stock.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/22/21.
//

import Foundation

class LocalStock: Decodable, Identifiable, Hashable, Equatable  {
 
    var id: UUID?
    var ticker: String
    var name: String
    var price: Double?
    var changesPercentage: Double?
    var change: Double?
    var dayLow: Double?
    var dayHigh: Double?
    var yearHigh: Double?
    var yearLow: Double?
    var marketCap: Double?
    var priceAvg50: Double?
    var priceAvg200: Double?
    var volume: Int?
    var avgVolume: Int?
    var exchange: String?
    var open: Double?
    var previousClose: Double?
    var eps: Double?
    var pe: Double?
    var earningsAnnouncement: String?
    var sharesOutStanding: Int?
    var timestamp: Int?
    var isFavorite: Bool?
    var historicalPrices: [Double]?
    var lastRefresh: Date?
    
    enum CodingKeys: String, CodingKey {
        case ticker = "symbol"
        case name
        case price
        case changesPercentage
        case change
        case dayLow
        case dayHigh
        case yearHigh
        case yearLow
        case marketCap
        case priceAvg50
        case priceAvg200
        case volume
        case avgVolume
        case exchange
        case open
        case previousClose
        case eps
        case pe
        case earningsAnnouncement
        case sharesOutStanding
        case timestamp
    }
    
    internal init(id: UUID? = nil, ticker: String, name: String, price: Double? = nil, changesPercentage: Double? = nil, change: Double? = nil, dayLow: Double? = nil, dayHigh: Double? = nil, yearHigh: Double? = nil, yearLow: Double? = nil, marketCap: Double? = nil, priceAvg50: Double? = nil, priceAvg200: Double? = nil, volume: Int? = nil, avgVolume: Int? = nil, exchange: String? = nil, open: Double? = nil, previousClose: Double? = nil, eps: Double? = nil, pe: Double? = nil, earningsAnnouncement: String? = nil, sharesOutStanding: Int? = nil, timestamp: Int? = nil, isFavorite: Bool? = nil, historicalPrices: [Double]? = nil, lastRefresh: Date? = nil) {
        self.id = id
        self.ticker = ticker
        self.name = name
        self.price = price
        self.changesPercentage = changesPercentage
        self.change = change
        self.dayLow = dayLow
        self.dayHigh = dayHigh
        self.yearHigh = yearHigh
        self.yearLow = yearLow
        self.marketCap = marketCap
        self.priceAvg50 = priceAvg50
        self.priceAvg200 = priceAvg200
        self.volume = volume
        self.avgVolume = avgVolume
        self.exchange = exchange
        self.open = open
        self.previousClose = previousClose
        self.eps = eps
        self.pe = pe
        self.earningsAnnouncement = earningsAnnouncement
        self.sharesOutStanding = sharesOutStanding
        self.timestamp = timestamp
        self.isFavorite = isFavorite
        self.historicalPrices = historicalPrices
        self.lastRefresh = lastRefresh
    }
    
    static func == (lhs: LocalStock, rhs: LocalStock) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

