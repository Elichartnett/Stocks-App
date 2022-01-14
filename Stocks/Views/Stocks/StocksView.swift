//
//  FavoriteStocksView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/23/21.
//

import SwiftUI

struct StocksView: View {
    
    @EnvironmentObject var model: StockModel
    @FetchRequest(sortDescriptors: [], predicate: NSPredicate(format: "isFavorite == true")) var favoriteStocks: FetchedResults<Stock>
    @Binding var selectedTab: String
    
    @State var selectedStock: String?
    @State var showSearchStocksView = false
    
    var body: some View {
        NavigationView {
            VStack {
                if favoriteStocks.isEmpty {
                    NoStocksView(showSearchStocksView: $showSearchStocksView)

                }
                else {
                    FavoritedStocksView(showSearchStocksView: $showSearchStocksView, selectedStock: $selectedStock)
                }
            }
            .sheet(isPresented: $showSearchStocksView) {
                SearchStocksView()
                    .padding()
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
}

struct StocksView_Previews: PreviewProvider {
    static var previews: some View {
        StocksView(selectedTab: .constant(Constants.FavoritesView)).environmentObject(StockModel())
    }
}
