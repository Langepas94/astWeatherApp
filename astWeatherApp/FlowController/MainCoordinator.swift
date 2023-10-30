//
//  FlowCoordinator.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import Combine

class MainCoordinator: UITabBarController {
    
    private var cancellables = Set<AnyCancellable>()
    var mainScreenViewModel: WeatherViewModel = WeatherViewModel()
    
    func goMainScreen() {
        
        mainScreenViewModel.coordinator = self
        
        let mainWeatherViewController = MainWeatherScreen(viewModel: mainScreenViewModel)
        
        let tableWithCitiesViewController = TableWithCitiesCoordinator()
        tableWithCitiesViewController.mainCoordinator = self
        
        setupBind(viewController: tableWithCitiesViewController)
        
        self.viewControllers = [mainWeatherViewController, tableWithCitiesViewController]
    }
    
    private func setupBind(viewController: TableWithCitiesCoordinator) {
        mainScreenViewModel.geoPublisher
            .sink(receiveValue: { model in
                viewController.reconfigure(city: model)
            })
            .store(in: &cancellables)
    }
    
    func reconfigure(city: City?) {
        if city == nil {
            mainScreenViewModel.loadWeather(from: nil)
        } else {
            mainScreenViewModel.loadWeather(from: city)
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        goMainScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

