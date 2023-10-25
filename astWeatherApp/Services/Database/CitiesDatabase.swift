//
//  DataBase.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import Combine

protocol IDataBase {
    func loadAllCities() -> Future<[City], Error>
    func searchCities(query: String) -> Future<[City], Never>
    func addToFavorite(city: City)
    func readFavorite() -> [City]?
    func deleteCity(city: City)
}

enum CityJSONError: Error {
    case error(String)
    
    var localizedDescription: String {
        switch self {
        case .error(let str):
            return str
        }
    }
}

class CitiesDatabase: IDataBase {
    
    var cities: [City] = []
    let userDefaults = UserDefaults.standard
    
    public func loadAllCities() -> Future<[City], Error> {
        Future { promise in
            DispatchQueue.global().async {
                do {
                    guard let url = Bundle.main.url(forResource: "citylist", withExtension: "json") else {
                        throw CityJSONError.error("File not found")
                    }
                    
                    let data = try Data(contentsOf: url)
                    let arr = try JSONDecoder().decode([City].self, from: data)
                    self.cities = arr
                    promise(.success(arr))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    
    public func searchCities(query: String) -> Future<[City], Never> {
        Future { promise in
            DispatchQueue.global().async {
                let arr: [City] = self.cities.filter { city in
                    return city.name?.contains(query) ?? false
                }
                promise(.success(arr))
            }
        }
    }
    
    public func addToFavorite(city: City) {
        if let data = userDefaults.data(forKey: "city") {
            guard var citiess = try? JSONDecoder().decode([City].self, from: data) else { return }
            if !citiess.contains(where: { $0.id == city.id }) {
                citiess.append(city)
                if let newCities = try? JSONEncoder().encode(citiess) {
                    userDefaults.set(newCities, forKey: "city")
                }
            }
        } else {
            var newCities = [City]()
            newCities.append(city)
            if let newCitiess = try? JSONEncoder().encode(newCities) {
                userDefaults.set(newCitiess, forKey: "city")
            }
        }
        userDefaults.synchronize()
    }
    
    public func readFavorite() -> [City]? {
        guard let data = userDefaults.data(forKey: "city") else { return nil}
        let cities = try? JSONDecoder().decode([City].self, from: data)
        return cities
    }
    
    public func deleteCity(city: City) {
        if let data = userDefaults.data(forKey: "city") {
            guard var citiess = try? JSONDecoder().decode([City].self, from: data) else { return }
            if let index = citiess.firstIndex(where: {$0.id == city.id}) {
                citiess.remove(at: index)
                if let newCitiess = try? JSONEncoder().encode(citiess) {
                    userDefaults.set(newCitiess, forKey: "city")
                    userDefaults.synchronize()
                }
            }
        }
      
    }
}
