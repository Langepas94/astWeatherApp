//
//  CityViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import Combine

class CityViewModel {
    private var cancellables = Set<AnyCancellable>()
    var updatePublisher = PassthroughSubject<WeatherModel, Never>()
    var reloadPublisher = PassthroughSubject<City, Never>()
    weak var coordinator: FlowCoordinator?
    weak var testcoordinator: WeatherListFlowController?
    var data: WeatherModel?
    @Published var tableData: [City] = []
    private var db: CitiesDatabase
    private var networkManager = NetworkManager()
    var filteredNamesPublisher = PassthroughSubject<[City], Never>()
    @Published var geoCityData: WeatherModel?
    
    func pressCity(city: City) {
        reloadPublisher.send(city)
    }
    
    func addGeoCity(city: WeatherModel) {
        self.geoCityData = city
    }
    
    func addToFavorite(city: City) {
//        db.addToFavorite(city: city)
        self.tableData = db.readFavorite() ?? [City]()
    }
    
    func readFavorite() {
        self.tableData = db.readFavorite() ?? [City]()
    }
    
    func fetchCityData(city: City) {
        guard let coord = city.coord, let lat = coord.lat , let lon = coord.lon else { return }
        networkManager.loadWeather(requestType: .forecast, requestWithData: .geoLocation(lat, lon))
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
    
    func loadAllCities() {
        db.loadAllCities()
            .receive(on: DispatchQueue.main)
                        .sink { completion in
                            switch completion {
                            case .finished: break
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        } receiveValue: {_ in
                           
                        }
                        .store(in: &cancellables)
    }
    
    func searchCities(query: String) {
        db.searchCities(query: query)
            .receive(on: DispatchQueue.main)
            .sink { filteredNames in
                self.filteredNamesPublisher.send(filteredNames)
            }
            .store(in: &self.cancellables)
    }
    
    func deleteCity(index: Int) {
        let city = self.tableData[index]
        self.tableData.remove(at: index)
        db.deleteCity(city: city)
    }
    
    init(db: CitiesDatabase) {
        self.db = db
    }
}
