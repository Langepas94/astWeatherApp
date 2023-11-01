//
//  WeatherViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import Combine

protocol IMainScreenWeatherViewModel: AnyObject {
    var updatePublisher: PassthroughSubject<WeatherModel, Never> { get }
    var geoPublisher: PassthroughSubject<WeatherModel, Never> { get }
    var coordinator: MainCoordinator? { get set }
    var data: WeatherModel? { get }
    func loadWeather(type: FetchType)
}

enum FetchType {
    case city(city: City)
    case geo
}

final class WeatherViewModel: IMainScreenWeatherViewModel {
    
    // MARK: Variables
    var geoPublisher = PassthroughSubject<WeatherModel, Never>()
    weak var coordinator: MainCoordinator?
    private var network: INetworkManager = NetworkManager()
    var data: WeatherModel?
    var updatePublisher = PassthroughSubject<WeatherModel, Never>()
    
    private var locationWorker = LocationWorker()
    private var cancellables = Set<AnyCancellable>()
    private var locations = (lat: 0.0, lon: 0.0)
    
    func loadWeather(type: FetchType) {
        switch type {
        case .city(city: let city):
            network(location: (city.coord?.lat ?? 0.0, city.coord?.lon ?? 0.0), publisher: updatePublisher)
        case .geo:
            locations = locationWorker.location
                       network(location: locations, publisher: updatePublisher)
        }
    }
    // MARK: Location
    private func loadLocation() {
        locationWorker.requestGeoSwitcher()
        locationWorker.locationPublisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                }
            }, receiveValue: { location in
                self.locations = location
                self.loadWeather(type: .geo)
                self.network(location: location, publisher: self.geoPublisher)
            })
            .store(in: &cancellables)
    }
    
    // MARK: Network
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
    
    // MARK: - Init
    init() {
        loadLocation()
    }
}


