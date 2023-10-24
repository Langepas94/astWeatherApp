//
//  WeatherViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import Combine
import CoreLocation

enum WeatherTypeFetch {
    case city(city: String)
    case geo
}

protocol IMainScreenWeatherViewModel {
    var network: INetworkManager { get set }
    var updatePublisher: PassthroughSubject<WeatherModel, Never> { get set }
    var coordinator: FlowCoordinator? { get set }
    func reloadData()
    func loadWeather(_ location: CLLocation)
    func loadWeather(_ city: String)
    var type: WeatherTypeFetch { get set }
}

class WeatherViewModel: IMainScreenWeatherViewModel {

    
    weak var coordinator: FlowCoordinator?
    var network: INetworkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    private var data: WeatherModel?
    var type: WeatherTypeFetch
    
    var updatePublisher = PassthroughSubject<WeatherModel, Never>()

    func loadWeather(_ location: CLLocation) {
        network.loadWeather(requestType: .forecast, requestWithData: .geoLocation(location.coordinate.latitude, location.coordinate.longitude))
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
    
    func loadWeather(_ city: String) {
        network.loadWeather(requestType: .forecast, requestWithData: .city(city))
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
    
    func reloadData() {
        //
    }
    
    
    init(type: WeatherTypeFetch) {
        self.type = type
    }
}
