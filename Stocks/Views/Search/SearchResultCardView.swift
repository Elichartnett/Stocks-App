//
//  SearchResultCardView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/23/21.
//

import SwiftUI

struct SearchResultCardView: View {
    
    @EnvironmentObject var model: StockModel
    var stock: LocalStock
    var color: Color
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(height: 30)
                .cornerRadius(10)
                .shadow(radius: 2)
            
            VStack {
                Text(stock.ticker)
                    .font(.caption2)
                    .bold()
                    .lineLimit(1)
                
                Text(stock.name)
                    .font(.caption2)
                    .lineLimit(1)
            }
            .foregroundColor(Color.black)
            .padding(.all, 5)
        }
    }
}

struct SearchResultCardView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultCardView(stock: LocalStock(ticker: "AAPL", name: "Apple"), color: Color.white)
            .environmentObject(StockModel())
    }
}
