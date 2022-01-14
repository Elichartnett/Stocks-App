//
//  StockDetailView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/22/21.
//

import SwiftUI

struct StockDetailView: View {
    
    @EnvironmentObject var model: StockModel
    var stock: Stock
    
    @State var refreshing = false
    
    var body: some View {
        if !refreshing {
            GeometryReader { geo in
                VStack(spacing: 20) {
                    StockStatsView(stock: stock, refreshing: $refreshing)
                    
                    VStack {
                        Text("YTD Graph")
                            .bold()
                        
                        StockGraphView(stock: stock)
                            .frame(height: 250)
                    }
                }
                .padding()
                .navigationTitle(stock.name)
            }
            .onAppear(perform: {
                UINavigationBar.appearance().tintColor = .black
            })
            .background(Constants.backgroundColor)
        }
        else {
            ProgressView()
        }
    }
}


struct StockDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let dataController = DataController()
        let moc = dataController.container.viewContext
        let stock = Stock(context: moc)
        
        StockDetailView(stock: stock)
            .environment(\.managedObjectContext, moc)
            .environmentObject(StockModel())
    }
}
