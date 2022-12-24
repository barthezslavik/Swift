//
//  ContentView.swift
//  Weather
//
//  Created by Slavik on 21.12.2022.
//

import SwiftUI
import Combine

struct WeatherView: View {
    @ObservedObject private var viewModel = WeatherViewModel()
    @State private var city: String = ""

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter a city", text: $city, onCommit: {
                    self.viewModel.fetchWeather(for: self.city)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

                Divider()

                if viewModel.weather != nil {
                    Text("Current temperature: \(viewModel.weather!.temperature)°F")
                    Text("Forecast:")
                    List(viewModel.weather!.forecast) { forecast in
                        Text("\(forecast.day): High of \(forecast.high)°F, Low of \(forecast.low)°F")
                    }
                } else {
                    Text("Enter a city to see the weather")
                }
            }
            .navigationBarTitle("Weather")
        }
    }
}

class WeatherViewModel: ObservableObject {
    @Published var weather: WeatherData?
    private var cancellables = Set<AnyCancellable>()

    func fetchWeather(for city: String) {
        WeatherAPI.shared.weather(for: city)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { self.weather = $0 })
            .store(in: &cancellables)
    }
}

struct WeatherData: Codable {
    let temperature: Int
    let forecast: [ForecastData]
}

struct WeatherAPI {
    static let shared = WeatherAPI()

    func weather(for city: String) -> AnyPublisher<WeatherData, Error> {
        // TODO: Implement the API call to fetch weather data for the given city
        return Future { promise in
            // simulate a long-running API call
            DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
                let weather = WeatherData(temperature: 73, forecast: [
                    ForecastData(day: "Monday", high: 80, low: 70),
                    ForecastData(day: "Tuesday", high: 82, low: 68)
                ])
                promise(.success(weather))
            }
        }
        .eraseToAnyPublisher()
    }
}

struct ForecastData: Codable, Identifiable {
    var id = UUID()  // add an 'id' property
    let day: String
    let high: Int
    let low: Int
}
