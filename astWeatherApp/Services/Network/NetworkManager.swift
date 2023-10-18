//
//  NetworkManager.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import Combine

enum RequestType: String {
    case forecast = "/data/2.5/forecast"
}

enum RequestWeatherWithData {
    case city(_ city: String)
    case geoLocation(_ latitude: Double,
                     _ longitude: Double)
}

enum WeatherError: Error {
    case networkError(Error)
    case invalidResponse
}

protocol INetworkManager {
    func loadWeather(requestType: RequestType,
                     requestWithData: RequestWeatherWithData)
    -> AnyPublisher<NetworkWeatherDataModel, Error>
}

final class NetworkManager: INetworkManager {
    
    let baseURL = URL(string: "https://api.openweathermap.org/")
    
    func loadWeather(requestType: RequestType,
                     requestWithData: RequestWeatherWithData)
    -> AnyPublisher<NetworkWeatherDataModel, Error> {
        
        let url = createURLComponents(requestWithData, requestType: requestType)
        guard let url = url?.url else { return Fail(error: WeatherError.invalidResponse).eraseToAnyPublisher() }
        return URLSession.shared.dataTaskPublisher(for: url)
            .mapError { error in
                WeatherError.networkError(error)
            }
            .map(\.data)
            .decode(type: NetworkWeatherDataModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func createURLComponents(_ request: RequestWeatherWithData, requestType: RequestType) -> URLComponents? {
        guard let baseURL = baseURL else { return nil }
        var urlComponents = URLComponents(url: baseURL,
                                          resolvingAgainstBaseURL: true)
        urlComponents?.path = requestType.rawValue
        
        switch request {
        case .city(let city):
            
            urlComponents?.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")]
            
            return urlComponents
        case .geoLocation(let lat, let lon):
            urlComponents?.queryItems = [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "appid", value: apiKey),
                URLQueryItem(name: "units", value: "metric")]
            return urlComponents
        }
    }
}
