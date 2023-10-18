//
//  WeatherViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import Combine

protocol IWeatherViewModel {
    var network: INetworkManager { get set }
    func loadWeather()
}

class WeatherViewModel: IWeatherViewModel {
 
    var network: INetworkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    private var data: WeatherModel?
    
    var updatePublisher = PassthroughSubject<WeatherModel, Never>()
    
    func loadWeather() {
        network.loadWeather(requestType: .forecast, requestWithData: .city("Langepas"))
            .sink { completion in
                switch completion {
                    
                case .finished:
                    guard let data = self.data else { return }
                    self.updatePublisher.send(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { weathers in
                self.data = WeatherModel(from: weathers)
            }
            .store(in: &cancellables)
    }
    
    init() {
        loadWeather()
    }
    
}
