//
//  StockModel.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/22/21.
//

import Foundation
import SwiftUI
import CoreData

@MainActor
class StockModel: ObservableObject {
    
    let managedObjectContext = DataController.shared.container.viewContext
    var favoriteStocks = [Stock]()
    @Published var showTicker = true
    
    func createStock(localStock: LocalStock) throws {
        let stock = Stock(context: managedObjectContext)
        stock.id = UUID()
        stock.ticker = localStock.ticker
        stock.name = localStock.name
        stock.price = localStock.price ?? 0.00
        stock.changesPercentage = localStock.changesPercentage ?? 0.00
        stock.change = localStock.change ?? 0.00
        stock.dayLow = localStock.dayLow ?? 0.00
        stock.dayHigh = localStock.dayHigh ?? 0.00
        stock.yearHigh = localStock.yearHigh ?? 0.00
        stock.yearLow = localStock.yearLow ?? 0.00
        stock.marketCap = localStock.marketCap ?? 0.00
        stock.priceAvg50 = localStock.priceAvg50 ?? 0.00
        stock.priceAvg200 = localStock.priceAvg200 ?? 0.00
        stock.volume = localStock.volume ?? 0
        stock.avgVolume = localStock.avgVolume ?? 0
        stock.exchange = localStock.exchange ?? ""
        stock.open = localStock.open ?? 0
        stock.previousClose = localStock.previousClose ?? 0.00
        stock.eps = localStock.eps ?? 0.00
        stock.pe = localStock.pe ?? 0.00
        stock.earningsAnnouncement = localStock.earningsAnnouncement ?? ""
        stock.sharesOutStanding = localStock.sharesOutStanding ?? 0
        stock.timestamp = localStock.timestamp ?? 0
        stock.isFavorite = localStock.isFavorite ?? true
        stock.historicalPrices = localStock.historicalPrices ?? [Double]()
        stock.lastRefresh = localStock.lastRefresh ?? Date.now
        do {
            try managedObjectContext.save()
        }
        catch {
            throw Errors.managedObjectContextError
        }
    }
    
    func getAvailableStocks(searchTerm: String) async throws -> [LocalStock] {
        var availableStocks = [LocalStock]()
        
        let url = URL(string: "https://financialmodelingprep.com/api/v3/search?query=\(searchTerm)&limit=99&exchange=NASDAQ&apikey=8ce56ed2133968d1425b83c057235d88")
        
        guard url != nil else {
            throw Errors.urlError
        }
        
        async let (data, response) = URLSession.shared.data(from: url!)
        do {
            let httpResponse = try await response as? HTTPURLResponse
            guard httpResponse?.statusCode == 200 else {
                throw Errors.connectionError
            }
            
            let stocks = try! JSONSerialization.jsonObject(with: await data, options: []) as? [[String:Any]]
            if stocks?.count != 0 {
                for index in 0..<(stocks?.count)! {
                    let ticker = stocks![index]["symbol"] as? String
                    let name = stocks![index]["name"] as? String
                    availableStocks.append(LocalStock(id: UUID(), ticker: ticker ?? "", name: name ?? ""))
                }
            }
        }
        catch {
            throw Errors.urlSessionError
        }
        return availableStocks
    }
    
    func getStockInfo(ticker: String) async throws -> LocalStock {
        var stock = LocalStock(ticker: "", name: "")
        let ticker = ticker.uppercased()
        
        let url = URL(string: "https://financialmodelingprep.com/api/v3/quote/\(ticker)?apikey=8ce56ed2133968d1425b83c057235d88")
        guard url != nil else {
            throw Errors.urlError
        }
        
        async let (data, response) = URLSession.shared.data(from: url!)
        do {
            let httpResponse = try await response as? HTTPURLResponse
            guard httpResponse?.statusCode == 200 else {
                throw Errors.connectionError
            }
            do {
                let decoder = JSONDecoder()
                let stockArray = try decoder.decode([LocalStock].self, from: await data)
                if stockArray.count != 0 {
                    stock = stockArray.first!
                    stock.id = UUID()
                    stock.isFavorite = true
                    stock.historicalPrices = try await getHistoricalData(ticker: ticker)
                    stock.lastRefresh = Date.now
                }
            }
            catch {
                throw Errors.decodingError
            }
        }
        catch {
            throw Errors.urlSessionError
        }
        return stock
    }
    
    func getHistoricalData(ticker: String) async throws -> [Double] {
        var prices = [Double]()
        
        let url = URL(string: "https://financialmodelingprep.com/api/v3/historical-price-full/\(ticker)?timeseries=253&apikey=8ce56ed2133968d1425b83c057235d88")
        
        guard url != nil else {
            throw Errors.urlError
        }
        
        async let (data, response) = URLSession.shared.data(from: url!)
        do {
            let httpResponse = try await response as? HTTPURLResponse
            guard httpResponse?.statusCode == 200 else {
                throw Errors.connectionError
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: try await data, options: []) as? [String:Any] {
                    let historicalArray = json["historical"] as? [[String:Any]]
                    for index in 0..<historicalArray!.count {
                        let day = historicalArray![historicalArray!.count - 1 - index]
                        let price = day["close"] as! Double
                        prices.append(price)
                    }
                }
            }
            catch {
                throw Errors.decodingError
            }
        }
        catch {
            throw Errors.urlSessionError
        }
        return prices
    }
    
    func refreshStock(stock: Stock) async throws {
        let localStock = try await getStockInfo(ticker: stock.ticker)
        stock.price = localStock.price ?? 0.00
        stock.changesPercentage = localStock.changesPercentage ?? 0.00
        stock.change = localStock.change ?? 0.00
        stock.dayLow = localStock.dayLow ?? 0.00
        stock.dayHigh = localStock.dayHigh ?? 0.00
        stock.yearHigh = localStock.yearHigh ?? 0.00
        stock.yearLow = localStock.yearLow ?? 0.00
        stock.marketCap = localStock.marketCap ?? 0.00
        stock.priceAvg50 = localStock.priceAvg50 ?? 0.00
        stock.priceAvg200 = localStock.priceAvg200 ?? 0.00
        stock.volume = localStock.volume ?? 0
        stock.avgVolume = localStock.avgVolume ?? 0
        stock.exchange = localStock.exchange ?? ""
        stock.open = localStock.open ?? 0
        stock.previousClose = localStock.previousClose ?? 0.00
        stock.eps = localStock.eps ?? 0.00
        stock.pe = localStock.pe ?? 0.00
        stock.earningsAnnouncement = localStock.earningsAnnouncement ?? ""
        stock.sharesOutStanding = localStock.sharesOutStanding ?? 0
        stock.timestamp = localStock.timestamp ?? 0
        stock.isFavorite = localStock.isFavorite ?? true
        stock.historicalPrices = localStock.historicalPrices ?? [Double]()
        stock.lastRefresh = Date.now
        do {
            try managedObjectContext.save()
        }
        catch {
            throw Errors.managedObjectContextError
        }
    }
    
    func fetchSavedStocks() throws {
        let request = NSFetchRequest<Stock>(entityName: "Stock")
        request.predicate = NSPredicate(format: "isFavorite == true")
        
        do {
            favoriteStocks = try managedObjectContext.fetch(request)
        }
        catch {
            throw Errors.managedObjectContextError
        }
    }
    
    func fetchAllStocks() {
        let request = NSFetchRequest<Stock>(entityName: "Stock")
        
        do {
            let stocks = try managedObjectContext.fetch(request)
            print("Core Data entities in memory:")
            for stock in stocks {
                print("- \(stock.name)")
            }
        }
        catch {
            print("Could  not fetch entities")
        }
    }
    
    func fetchStock(ticker: String) throws -> Stock {
        do {
            try fetchSavedStocks()
            if let index = favoriteStocks.firstIndex(where: { stock in
                stock.ticker == ticker
            }) {
                return favoriteStocks[index]
            }
            else {
                throw Errors.managedObjectContextError
            }
        }
        catch {
            throw Errors.managedObjectContextError
        }
    }
    
    func deleteStock(stock: Stock) throws {
        managedObjectContext.delete(stock)
        do {
            try managedObjectContext.save()
        }
        catch {
            throw Errors.managedObjectContextError
        }
    }
    
    func formatNum(number: Double) -> String {
        let formattedNum = String(format: "$%.2f", number)
        return formattedNum
    }
}
