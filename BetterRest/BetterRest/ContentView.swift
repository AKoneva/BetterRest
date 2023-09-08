//
//  ContentView.swift
//  BetterRest
//
//  Created by Анна Перехрест  on 2023/09/08.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
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
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)

            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep

            alertTitle = "Your ideal bedtime is…"
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            showingAlert.toggle()
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            showingAlert.toggle()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
