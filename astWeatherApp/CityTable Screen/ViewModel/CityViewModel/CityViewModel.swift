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
    weak var testcoordinator: TableVithCitiesCoordinator?
    @Published var tableData: [City] = []
    private var db: CitiesDatabase
    private var networkManager = NetworkManager()
    var filteredNamesPublisher = PassthroughSubject<[City], Never>()
    @Published var geoCityData: WeatherModel?
    
    func pressCity(city: City) {
        print("press city")
        reloadPublisher.send(city)
    }
    
    func pressGeo() {
        print("press geo")
        testcoordinator?.pressGeo()
    }
    
    func setGeoCity(city: WeatherModel) {
            self.geoCityData = city
    }
    
    func addToFavorite(city: City) {
        self.tableData = db.readFavorite() ?? [City]()
    }
    
    func readFavorite() {
        self.tableData = db.readFavorite() ?? [City]()
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
