//
//  WeatherViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import Combine

protocol IMainScreenWeatherViewModel {
    var network: INetworkManager { get set }
    var updatePublisher: PassthroughSubject<WeatherModel, Never> { get set }
    var geoPublisher: PassthroughSubject<WeatherModel, Never> { get set }
    var coordinator: MainCoordinator? { get set }
    var data: WeatherModel? { get set }
    func loadWeather(from city: City?)
}

class WeatherViewModel: IMainScreenWeatherViewModel {
    
    // MARK: Variables
    var geoPublisher = PassthroughSubject<WeatherModel, Never>()
    weak var coordinator: MainCoordinator?
    var network: INetworkManager = NetworkManager()
    var data: WeatherModel?
    var updatePublisher = PassthroughSubject<WeatherModel, Never>()
    
    private var locationWorker = LocationWorker()
    private var cancellables = Set<AnyCancellable>()
    private var locations = (lat: 0.0, lon: 0.0)
    
    func loadWeather(from city: City?) {
        if city != nil {
            network(location: (city?.coord?.lat ?? 0.0, city?.coord?.lon ?? 0.0), publisher: updatePublisher)
        } else {
            locations = locationWorker.location
            network(location: locations, publisher: updatePublisher)
        }
    }
    
    private func loadLocation() {
        locationWorker.requestGeoSwitcher()
        locationWorker.locationPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] location in
                
                self?.locations = location
                self?.loadWeather(from: nil)
                self?.network(location: location, publisher: self?.geoPublisher)
            })
            .store(in: &cancellables)
    }
    
    private func network(location: (lat: Double, lon: Double), publisher: PassthroughSubject<WeatherModel, Never>?) {
        network.loadWeather(requestType: .forecast, requestWithData: .geoLocation(location.lat, location.lon))
            .sink { completion in
                switch completion {
                case .finished:
                    guard let data = self.data else { return }
                    publisher?.send(data)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] weathers in
                self?.data = WeatherModel(from: weathers)
            }
            .store(in: &self.cancellables)
    }
    
    init() {
        loadLocation()
    }
}


