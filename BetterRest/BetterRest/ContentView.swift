//
//  ContentView.swift
//  BetterRest
//
//  Created by Анна Перехрест  on 2023/09/08.
//

import SwiftUI


struct ContentView: View {
    @State private var wakeUp = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    var body: some View {
        ZStack {
            RadialGradient(gradient: Gradient(colors: [
                Color(.init(red: 0.8, green: 0.8, blue: 0.4, alpha: 0.6)),
                Color(.init(red: 0.4, green: 0.3, blue: 0.8, alpha: 0.6))
            ]), center: .center, startRadius: 50, endRadius: 600)
                .ignoresSafeArea()

            VStack {
                VStack(spacing: 30) {
                                Text("When do you want to wake up?")
                                    .font(.headline)
                                
                                DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                                    .labelsHidden()
                                
                                Text("Desired amount of sleep")
                                    .font(.headline)
                                
                                Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                                
                                Text("Daily coffee intake")
                                    .font(.headline)
                                
                                Stepper(coffeeAmount == 1 ? "1 cup" : "\(coffeeAmount) cups", value: $coffeeAmount, in: 1...20)
                            }
                            .padding()
                            .background(.thinMaterial)
                            .cornerRadius(30)
                            .padding()
                
                Button {
                    calculateBedtime()
                } label: {
                    Text("Calculate")
                        .padding()
                        .foregroundColor(.primary)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedtime() {
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
