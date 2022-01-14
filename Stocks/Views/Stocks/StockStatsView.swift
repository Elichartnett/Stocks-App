//
//  OpenHighLowCardView.swift
//  Stocks
//
//  Created by Eli Hartnett on 1/8/22.
//

import SwiftUI

struct StockStatsView: View {
    
    @EnvironmentObject var model: StockModel
    var stock: Stock
    @Binding var refreshing: Bool
    
    @State var presentAlert = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .cornerRadius(10)
                .shadow(color: .white, radius: 3)
            
            VStack(spacing: 20) {
                VStack {
                    HStack {
                        Text("Today's stats")
                            .bold()
                        
                        Button {
                            Task {
                                do {
                                    refreshing = true
                                    try await model.refreshStock(stock: stock)
                                    refreshing = false
                                }
                                catch {
                                    presentAlert = true
                                    throw Errors.managedObjectContextError
                                }
                            }
                        }
                    label: {
                        ZStack {
                            Rectangle()
                                .fill(.white)
                                .frame(width:90, height: 30)
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            
                            Text("Refresh")
                                .foregroundColor(.black)
                        }
                    }
                    }
                    .alert("Error", isPresented: $presentAlert, actions: {}, message: {
                        Text("Could not refresh")
                    })
                    
                    Text("Last refreshed \(stock.lastRefresh, format: .dateTime.day().month().year()) at \(stock.lastRefresh, format: .dateTime.hour().minute().second())")
                        .font(.caption)
                }
                
                HStack {
                    Spacer()
                    VStack {
                        Text("Price")
                            .bold()
                        Text(model.formatNum(number: stock.price ))
                    }
                    Spacer()
                    VStack {
                        Text(model.formatNum(number: stock.change ))
                        Text(String(format: "%.2f", stock.changesPercentage ) + "%")
                    }
                    .foregroundColor(stock.change.sign == .minus ? Color.red : stock.change > 0.00 ? Color.green : Color.black)
                    Spacer()
                }
                
                LazyVGrid (columns: Array(repeating: GridItem(.flexible(minimum: 0, maximum: .infinity)), count: 3), content: {
                    VStack {
                        Text("Open")
                            .bold()
                        Text(model.formatNum(number: stock.open ))
                    }
                    
                    VStack {
                        Text("High")
                            .bold()
                        Text(model.formatNum(number: stock.dayHigh ))
                    }
                    VStack {
                        Text("Low")
                            .bold()
                        Text(model.formatNum(number: stock.dayLow ))
                    }
                })
            }
        }
        .frame(height: 200)
    }
}

struct OpenHighLowCardView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let moc = dataController.container.viewContext
        let stock = Stock(context: moc)
        
        StockStatsView(stock: stock, refreshing: .constant(false))
            .environmentObject(StockModel())
    }
}
