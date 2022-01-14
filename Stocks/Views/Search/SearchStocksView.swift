//
//  SearchStocksView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/23/21.
//

import SwiftUI

struct SearchStocksView: View {
    
    @EnvironmentObject var model: StockModel
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isFavorite == true")) var favoritedStocks: FetchedResults<Stock>
    
    @State var searchTerm = ""
    @State var searchResults = [LocalStock]()
    @State var presentAlert = false
    
    var body: some View {
        VStack {
            HStack {
                SearchBarView(searchTerm: $searchTerm, searchResults: $searchResults)
                
                Button {
                    Task {
                        searchResults.removeAll()
                        do {
                            searchResults = try await model.getAvailableStocks(searchTerm: searchTerm)
                        }
                        catch {
                            presentAlert = true
                        }
                    }
                } label: {
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing)
                }
            }
            .foregroundColor(Color.black)
            .alert("Error", isPresented: $presentAlert, actions: {}, message: {
                Text("Search failed")
            })
            
            ScrollView {
                let col = GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 0)
                LazyVGrid (columns: Array(repeating: col, count: 3), alignment: .center, spacing: 0, content: {
                    ForEach(searchResults) { result in
                        Button {
                            Task {
                                do {
                                    if let index = favoritedStocks.firstIndex(where: { favoriteStock in
                                        favoriteStock.ticker == result.ticker
                                    })
                                    {
                                        try model.deleteStock(stock: favoritedStocks[index])
                                        
                                    }
                                    else {
                                        let localStock = try await model.getStockInfo(ticker: result.ticker)
                                        try model.createStock(localStock: localStock)
                                    }
                                }
                                catch {
                                    presentAlert = true
                                    throw Errors.managedObjectContextError
                                }
                            }
                        } label: {
                            SearchResultCardView(stock: result, color: favoritedStocks.contains(where: { favoriteStock in
                                favoriteStock.ticker == result.ticker
                            }) ? Color.green : Color.white)
                                .padding(.horizontal, 3)
                        }
                    }
                })
            }
            .alert("Error", isPresented: $presentAlert, actions: {}, message: {
                Text("Could not complete request")
            })
        }
    }
}

struct SearchStocksView_Previews: PreviewProvider {
    static var previews: some View {
        SearchStocksView()
            .environmentObject(StockModel())
    }
}
