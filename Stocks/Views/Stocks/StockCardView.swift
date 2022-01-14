//
//  StockCardView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/22/21.
//

import SwiftUI

struct StockCardView: View {
    
    @EnvironmentObject var model: StockModel
    var stockTicker: String
    var stockName: String
    var stockPrice: Double
    
    @State var offset: CGFloat = 0
    @State var presentAlert = false

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.white)
                .frame(height: 60)
                .cornerRadius(10)
                .shadow(color: .white, radius: 3)
            
            VStack {
                Text("\(stockName)\(model.showTicker ? " - " : "")\(model.showTicker ? stockTicker : "")")
                    .font(.title3)
                    .bold()
                    .lineLimit(1)
                    .padding(.horizontal)
                
                Text(model.formatNum(number: stockPrice))
                    .font(.subheadline)
            }
        }
        .padding(.horizontal, 3)
        .offset(x: offset)
        .foregroundColor(.black)
        .padding(.vertical, 2)
        .gesture(
            DragGesture()
                .onChanged({ value in
                    withAnimation(.spring()) {
                        offset = value.translation.width
                    }
                })
                .onEnded({ value in
                    withAnimation(.spring()) {
                        if offset < -250 {
                            do {
                            let stock = try model.fetchStock(ticker: stockTicker)
                                try model.deleteStock(stock: stock)
                            }
                            catch {
                                presentAlert = true
                            }
                        }
                        else {
                            offset = 0
                        }
                    }
                })
        )
        .alert("Error", isPresented: $presentAlert, actions: {}, message: {
            Text("Could not complete request")
        })

    }
}

struct StockCardView_Previews: PreviewProvider {
    static var previews: some View {
        StockCardView(stockTicker: "AAPL", stockName: "Apple", stockPrice: 100.00)
            .environmentObject(StockModel())
    }
}
