//
//  FavoritedStocksView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/30/21.
//

import SwiftUI

struct FavoritedStocksView: View {
    
    @EnvironmentObject var model: StockModel
    let defaults = UserDefaults.standard
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)], predicate: NSPredicate(format: "isFavorite == true")) var favoriteStocks: FetchedResults<Stock>
    @Binding var showSearchStocksView: Bool
    @Binding var selectedStock: String?
    
    @State var isPressed = false
    
    var body: some View {
        VStack {
            Text("Favorite Stocks")
                .font(.largeTitle)
                .bold()
            
            Button("") {
                showSearchStocksView = true
            }
            .buttonStyle(AddStockButton())
            
            ScrollView {
                ForEach(favoriteStocks) { stock in
                    NavigationLink(tag: stock.ticker, selection: $selectedStock, destination: {
                        StockDetailView(stock: stock)
                    }, label: {
                        StockCardView(stockTicker: stock.ticker, stockName: stock.name, stockPrice: stock.price)
                            .foregroundColor(.black)
                            .padding(.vertical, 2)
                    })
                }
            }
        }
        .padding(.horizontal)
        .background(Constants.backgroundColor)
        .onAppear(perform: {
            model.showTicker = defaults.object(forKey: "showTicker") as? Bool ?? true
        })
    }
}

struct FavoritedStocksView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritedStocksView(showSearchStocksView: .constant(false), selectedStock: .constant(""))
            .environmentObject(StockModel())
    }
}
