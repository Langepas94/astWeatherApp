//
//  CityViewModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import Combine

protocol ICityViewModel {
    var updatePublisher: PassthroughSubject<WeatherModel, Never> { get }
    var reloadPublisher: PassthroughSubject<City, Never> { get }
    var tableDataPublisher: Published<[City]>.Publisher { get }
    var geoDataPublisher: Published<WeatherModel?>.Publisher { get }
    var filteredNamesPublisher: PassthroughSubject<[City], Never> { get }
    var tableData: [City] { get set }
    var coordinator: TableWithCitiesCoordinator? { get set }
    var geoCityData: WeatherModel? { get }
    func pressGeo()
    func setGeoCity(city: WeatherModel)
    func addToFavorite(city: City)
    func readFavorite()
    func searchCities(query: String)
    func deleteCity(index: Int)
    func pressCity(city: City)
}

final class CityViewModel: ObservableObject, ICityViewModel {
    
    //MARK: - Variables
    var geoDataPublisher: Published<WeatherModel?>.Publisher {$geoCityData}
    var tableDataPublisher: Published<[City]>.Publisher { $tableData }
    var updatePublisher = PassthroughSubject<WeatherModel, Never>()
    var reloadPublisher = PassthroughSubject<City, Never>()
    var filteredNamesPublisher = PassthroughSubject<[City], Never>()
    @Published internal var tableData: [City] = []
    @Published var geoCityData: WeatherModel?
    
    weak var coordinator: TableWithCitiesCoordinator?
    
    private var db: CitiesDatabase = CitiesDatabase()
    private var networkManager = NetworkManager()
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Flow
    
    func pressCity(city: City) {
        reloadPublisher.send(city)
    }
    
    func pressGeo() {
        coordinator?.geoCellPressed()
    }
    
    func setGeoCity(city: WeatherModel) {
        self.geoCityData = city
    }
    
    func addToFavorite(city: City) {
        db.addToFavorite(city: city)
        self.tableData = db.readFavorite() ?? [City]()
    }
    
    func readFavorite() {
        self.tableData = db.readFavorite() ?? [City]()
    }
    
    // MARK: Search
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
    
    // MARK: - Init
    init() {
        readFavorite()
//        loadAllCities()
    }
}
