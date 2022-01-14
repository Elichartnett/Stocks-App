//
//  NoStocksView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/30/21.
//

import SwiftUI

struct NoStocksView: View {
    
    @Binding var showSearchStocksView: Bool
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Text("No favorites")
                    .font(.largeTitle)
                    .bold()
                
                Button("") {
                    showSearchStocksView = true
                }
                .buttonStyle(AddStockButton())
            }
            .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
            .background(Constants.backgroundColor)
        }
    }
}

struct NoStocksView_Previews: PreviewProvider {
    static var previews: some View {
        NoStocksView(showSearchStocksView: .constant(false))
    }
}
