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
    let textNowDescription: String
    let maxMinDescription: String
    
    init?(from network: NetworkWeatherDataModel) {
        self.cityName = network.city?.name ?? ""
        self.nowDegrees = network.list?.first?.main?.temp?.rounded(numAfter: 1) ?? 0.0
        self.description = network.list?.first?.weather?.first?.description ?? ""
        self.maxDegrees = network.list?.first?.main?.tempMax?.rounded(numAfter: 1) ?? 0.0
        self.minDegrees = network.list?.first?.main?.tempMin?.rounded(numAfter: 1) ?? 0.0
        self.weekData = network.list ?? [List]()
        self.icon = network.list?.first?.weather?.first?.icon ?? ""
        self.textNowDescription = "\(String(describing: nowDegrees))" + "°C"
        self.maxMinDescription = "Min: \(String(describing: minDegrees))°C Max: \(String(describing: maxDegrees))°C"
    }
    
    internal init(cityName: String = "", nowDegrees: Double = 0.0, description: String = "", maxDegrees: Double = 0.0, minDegrees: Double = 0.0, weekData: [List] = [List](), icon: String = "", textNowDescription: String = "", maxMinDescription: String = "") {
        self.cityName = cityName
        self.nowDegrees = nowDegrees
        self.description = description
        self.maxDegrees = maxDegrees
        self.minDegrees = minDegrees
        self.weekData = weekData
        self.icon = icon
        self.textNowDescription = textNowDescription
        self.maxMinDescription = maxMinDescription
    }
}
