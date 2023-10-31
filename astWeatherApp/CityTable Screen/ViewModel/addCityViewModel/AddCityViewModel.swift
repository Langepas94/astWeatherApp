//
//  AddCityViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 25.10.2023.
//

import Foundation
import Combine

protocol IAddCityViewModel: AnyObject {
    func fetchWeather(city: City)
    var updatePublisher: PassthroughSubject<WeatherModel, Never> { get }
    var data: WeatherModel? { get set }
    func addCity(city: City)
    var coordinator: TableWithCitiesCoordinator? { get set }
}

final class AddCityViewModel: IAddCityViewModel {
    
    //MARK: Variables
    var updatePublisher: PassthroughSubject<WeatherModel, Never> = PassthroughSubject<WeatherModel, Never>()
    var data: WeatherModel?
    
    weak var coordinator: TableWithCitiesCoordinator?
    
    private let network = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Fetch Weather
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
            } receiveValue: { [weak self] weathers in
                self?.data = WeatherModel(from: weathers)
            }
            .store(in: &self.cancellables)
    }
    
    // MARK: Add city
    func addCity(city: City) {
        coordinator?.addCityToFavorite(city: city)
    }
}
