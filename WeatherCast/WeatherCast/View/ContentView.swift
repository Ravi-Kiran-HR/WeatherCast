//
//  ContentView.swift
//  WeatherCast
//
//  Created by Ravi Kiran HR on 04/02/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var location = ""
    @ObservedObject var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter the city name", text: $location) { _ in } onCommit: {
                self.viewModel.fetch(city: self.location)
            }.font(.title)
            Divider()
            Text("\(self.viewModel.weatherInfo)").font(.body)
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
