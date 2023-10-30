//
//  AddCityViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 25.10.2023.
//

import Foundation
import Combine

protocol IAddCityViewModel {
    func fetchWeather(city: City)
    var updatePublisher: PassthroughSubject<WeatherModel, Never> { get set }
    var data: WeatherModel? { get set }
    func addCity(city: City)
    var coordinator: TableWithCitiesCoordinator? { get set }
}

class AddCityViewModel: IAddCityViewModel {
    
    private let network = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    var updatePublisher: PassthroughSubject<WeatherModel, Never> = PassthroughSubject<WeatherModel, Never>()
    var data: WeatherModel?
    
    weak var coordinator: TableWithCitiesCoordinator?
    
    func fetchWeather(city: City) {
        guard let coord = city.coord, let lat = coord.lat, let lon = coord.lon else { return }
        self.network.loadWeather(requestType: .forecast, requestWithData: .geoLocation(lat, lon))
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
    
    func addCity(city: City) {
        coordinator?.goAddCity(city: city)
    }
}
