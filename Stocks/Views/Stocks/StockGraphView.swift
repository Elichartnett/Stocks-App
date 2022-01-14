//
//  StockGraphView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/24/21.
//

import SwiftUI

struct StockGraphView: View {
    
    @EnvironmentObject var model: StockModel
    var stock: Stock
    
    @State var points: [CGPoint]?
    @State var minPoint: Double?
    @State var maxPoint: Double?
    @State var numPoints: Int?
    @State var width: Double?
    @State var height: Double?
    @State var indicatorX: CGFloat = 0
    @State var indicatorY: CGFloat = 0
    @State var indicatorVal: String?
    @State var indicatorValPosition = CGPoint(x: 37.5, y: 0)
    @State var showGraph = false
    @State var opacity: Double = 0
    @State var percentage: CGFloat = 0
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.white)
                .cornerRadius(10)
                .shadow(color: .white, radius: 3)
            
            HStack(spacing: 0) {
                ZStack {
                    VStack {
                        Text(model.formatNum(number: stock.historicalPrices.max() ?? 0))
                            .frame(alignment: .top)
                        
                        Spacer()
                        
                        Text(model.formatNum(number: stock.historicalPrices.min() ?? 0))
                    }
                    
                    Text(indicatorVal ?? "0.00")
                        .position(indicatorValPosition)
                        .opacity(opacity)
                        .onChange(of: indicatorY) { newValue in
                            withAnimation() {
                                if indicatorY > 40 && indicatorY < height!-40 {
                                    opacity = 1.0
                                }
                                else {
                                    opacity = 0.0
                                }
                            }
                        }
                }
                .frame(width: 75)
                
                GeometryReader { proxy in
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 5, height: 5))
                            .stroke()
                        
                        if points != nil {
                            ZStack {
                                if showGraph {
                                    ZStack {
                                        let path = Path { p in
                                            p.addLines((points?.reversed())!)
                                        }
                                        
                                        path
                                            .trim(from: 0, to: percentage)
                                            .stroke(.black)
                                            .shadow(color: Color("customDarkBlue"), radius: 10, x: 0, y: 10)
                                            .shadow(color: Color("customDarkBlue").opacity(0.5), radius: 10, x: 0, y: 20)
                                            .shadow(color: Color("customDarkBlue").opacity(0.2), radius: 10, x: 0, y: 30)
                                            .shadow(color: Color("customDarkBlue").opacity((0.1)), radius: 10, x: 0, y: 40)
                                            .onAppear {
                                                withAnimation(.linear(duration: 3)) {
                                                    percentage = 1
                                                }
                                            }
                                    }
                                }
                                
                                Circle()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(Color.blue)
                                    .onAppear(perform: {
                                        indicatorX = points![points!.count-1].x
                                        indicatorY = points![points!.count-1].y
                                        indicatorValPosition = CGPoint(x: 37.5, y: indicatorY)
                                        indicatorVal = model.formatNum(number: stock.historicalPrices[0])
                                    })
                                    .position(x: indicatorX, y: indicatorY)
                                    .gesture(
                                        DragGesture()
                                            .onChanged({ value in
                                                if value.location.x > 0 && value.location.x < width! {
                                                    indicatorX = value.location.x
                                                    
                                                    if let index = points?.firstIndex(where: { point in
                                                        indicatorX.rounded().isEqual(to: point.x)
                                                    }) {
                                                        indicatorY = points![index].y
                                                        withAnimation(.spring()) {
                                                            indicatorValPosition = CGPoint(x: 37.5, y: indicatorY)
                                                        }
                                                        indicatorVal = model.formatNum(number: (1-(indicatorY/height!))*(maxPoint!-minPoint!)+minPoint!)
                                                    }
                                                }
                                            }))
                            }
                            .onAppear {
                                withAnimation {
                                    showGraph = true
                                }
                            }
                        }
                        else {
                            ProgressView()
                        }
                    }
                    .onAppear {
                        numPoints = stock.historicalPrices.count
                        if !stock.historicalPrices.isEmpty {
                            points = [CGPoint](repeating: CGPoint(), count: numPoints!)
                        }
                        createPoints(proxy: proxy)
                    }
                }
            }
            .padding()
        }
    }
    
    // historical prices: [oldest->newest]
    // points - must flip over y-axis for graph and drag gesture: [(max x, oldest y) -> (min x, newest y)]
    func createPoints(proxy: GeometryProxy) {
        minPoint = stock.historicalPrices.min() ?? 0.00
        maxPoint = stock.historicalPrices.max() ?? 0.00
        width = proxy.size.width
        height = proxy.size.height
        
        for (index, point) in stock.historicalPrices.enumerated() {
            let offsetIndex: Double = (Double(index)/Double(numPoints!-1))*width!
            let offsetPoint: Double = ((point-minPoint!)/(maxPoint!-minPoint!))*height!
            points![numPoints!-index-1].x  = offsetIndex.rounded()
            points![index].y = offsetPoint.rounded()
        }
    }
}

struct LineChartView_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        let moc = dataController.container.viewContext
        
        StockGraphView(stock: Stock(context: moc))
            .environmentObject(StockModel())
            .environment(\.managedObjectContext, moc)
    }
}
