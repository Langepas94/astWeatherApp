//
//  FlowCoordinator.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import Combine

//protocol IFlowController: UIViewController {
//    func configureMainScreen(fetchType: WeatherTypeFetch)
//    func showTable()
//}

class MainCoordinator: UITabBarController {
    
    private var cancellables = Set<AnyCancellable>()
    var mainScreenViewModel: WeatherViewModel = WeatherViewModel()
    
    func configureCoordinator() {
        
        
        mainScreenViewModel.coordinator = self

        let mainWeatherViewController = MainWeatherScreen(viewModel: mainScreenViewModel)
        
        let tableWithCitiesViewController = TableVithCitiesCoordinator()
        tableWithCitiesViewController.mainCoordinator = self
        
        mainWeatherViewController.tabBarItem.image = UIImage(systemName: "house")
        mainWeatherViewController.title = "Home"
        
        tableWithCitiesViewController.tabBarItem.image = UIImage(systemName: "play.circle")
        tableWithCitiesViewController.title = "Table"

        self.viewControllers = [mainWeatherViewController, tableWithCitiesViewController]
        
        mainScreenViewModel.geoPublisher
            .sink(receiveValue: { model in
                tableWithCitiesViewController.reconfigure(city: model)
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
        configureCoordinator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

