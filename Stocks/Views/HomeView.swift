//
//  HomeView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/22/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model: StockModel
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var selectedTab = Constants.FavoritesView
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            StocksView(selectedTab: $selectedTab)
                .tag(Constants.FavoritesView)
                .tabItem {
                    VStack {
                        Image(systemName: "star")
                        Text("Favorites")
                    }
                }
            
            SettingsView()
                .tag(Constants.SettingsView)
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                }
        }
        .accentColor(Color("customDarkBlue"))
        .onAppear {
            model.fetchAllStocks()
            UITabBar.appearance().backgroundColor = .white
            UITabBar.appearance().unselectedItemTintColor = .gray
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(StockModel())
    }
}
