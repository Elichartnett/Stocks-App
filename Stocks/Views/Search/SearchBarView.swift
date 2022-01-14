//
//  SearchBarView.swift
//  Stocks
//
//  Created by Eli Hartnett on 12/22/21.
//

import SwiftUI

struct SearchBarView: View {
    
    @EnvironmentObject var model: StockModel
    @Binding var searchTerm: String
    @Binding var searchResults: [LocalStock]
    
    @State var presentAlert = false
    @FocusState var searchInFocus: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 243/255, green: 243/255, blue: 243/255))
                .cornerRadius(10)
            
            HStack {
                TextField("Search", text: $searchTerm)
                    .focused($searchInFocus)
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(SwiftUI.TextInputAutocapitalization.never)
                    .padding(.leading)
                    .onSubmit {
                        Task {
                            do {
                                searchResults = try await model.getAvailableStocks(searchTerm: searchTerm)
                            }
                            catch {
                                presentAlert = true
                            }
                        }
                    }
                
                Button {
                    searchTerm = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing)
            }
        }
        .onTapGesture {
            searchInFocus = true
        }
        .frame(height: 40)
        .alert("Error", isPresented: $presentAlert, actions: {}, message: {
            Text("Could not complete request")
        })
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchTerm: .constant("AAPL"), searchResults: .constant([LocalStock(ticker: "AAPL", name: "Apple")]))
            .environmentObject(StockModel())
    }
}
