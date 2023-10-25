//
//  WeatherViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import Combine
import CoreLocation


protocol IMainScreenWeatherViewModel {
    var network: INetworkManager { get set }
    var updatePublisher: PassthroughSubject<WeatherModel, Never> { get set }
    var coordinator: FlowCoordinator? { get set }
    func loadWeather(from city: City?)
}

class WeatherViewModel: IMainScreenWeatherViewModel {
    
    private var locationWorker = LocationWorker()
    weak var coordinator: FlowCoordinator?
    var network: INetworkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    private var data: WeatherModel?
    
    var updatePublisher = PassthroughSubject<WeatherModel, Never>()
    
    func loadWeather(from city: City?) {
        locationWorker.fetchGeo(from: city)
        locationWorker.$location
            .sink { location in
                guard let location = location else { return }
                self.network.loadWeather(requestType: .forecast, requestWithData: .geoLocation(location.coordinate.latitude, location.coordinate.longitude))
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
                                .store(in: &self.cancellables)
            }
            .store(in: &self.cancellables)
    }
    
}
