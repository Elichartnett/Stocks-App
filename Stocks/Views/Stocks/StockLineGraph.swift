//
//  StockLineGraph.swift
//  Stocks
//
//  Created by Eli Hartnett on 1/4/22.
//

import SwiftUI

struct StockLineGraph: Shape {
    
    let points: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
            let path = Path { p in
                p.addLines(points)
            }
        
        return path
    }
}

struct StockLineGraph_Previews: PreviewProvider {
    static var previews: some View {
        StockLineGraph(points: [CGPoint(x: 0, y: 100), CGPoint(x: 100, y: 200), CGPoint(x: 200, y: 300), CGPoint(x: 200, y: 500)])
    }
}
