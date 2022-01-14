//
//  SettingsView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/26/21.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var model: StockModel
    let defaults = UserDefaults.standard
    
    @State var showTicker = true
    
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .bold()
            
            Form {
                Section {
                    Toggle(isOn: $showTicker){
                        Text("Show stock symbol")
                            .font(.title)
                    }
                }
                .onChange(of: showTicker) { newValue in
                    model.showTicker = newValue
                    defaults.set(newValue, forKey: "showTicker")
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
            .onAppear(perform: {
                showTicker = model.showTicker
            })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(StockModel())
    }
}
