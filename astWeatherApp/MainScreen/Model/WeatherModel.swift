//
//  WeatherModel.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation

struct WeatherModel {
    
    let cityName: String
    let nowDegrees: Double
    let description: String
    let maxDegrees: Double
    let minDegrees: Double
    let weekData: [List]
    let icon: String
    
    init?(from network: NetworkWeatherDataModel) {
        self.cityName = network.city?.name ?? ""
        self.nowDegrees = network.list?.first?.main?.temp ?? 0.0
        self.description = network.list?.first?.weather?.first?.description ?? ""
        self.maxDegrees = network.list?.first?.main?.tempMax ?? 0.0
        self.minDegrees = network.list?.first?.main?.tempMin ?? 0.0
        self.weekData = network.list ?? [List]()
        self.icon = network.list?.first?.weather?.first?.icon ?? ""
    }
    
    internal init(cityName: String = "", nowDegrees: Double = 0.0, description: String = "", maxDegrees: Double = 0.0, minDegrees: Double = 0.0, weekData: [List] = [List](), icon: String = "") {
        self.cityName = cityName
        self.nowDegrees = nowDegrees
        self.description = description
        self.maxDegrees = maxDegrees
        self.minDegrees = minDegrees
        self.weekData = weekData
        self.icon = icon
    }
}
