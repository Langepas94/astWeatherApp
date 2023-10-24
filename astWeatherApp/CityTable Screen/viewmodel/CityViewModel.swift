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
    var updatePublisher = PassthroughSubject<String, Never>()
    weak var coordinator: FlowCoordinator?
    
    func pressCity(city: String) {
        updatePublisher.send(city)
    }
}
