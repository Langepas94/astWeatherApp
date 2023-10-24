//
//  FlowCoordinator.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import Combine

protocol IFlowController: UIViewController {
    func configureMainScreen(fetchType: WeatherTypeFetch)
    func showTable()
}

class FlowCoordinator: UITabBarController {
    
    var secondViewModel = CityViewModel()
    private var cancellables = Set<AnyCancellable>()
    var mainScreenViewModel: WeatherViewModel?
    
    func configureCoordinator(fetchType: WeatherTypeFetch) {
        
        mainScreenViewModel = WeatherViewModel(type: fetchType)
        mainScreenViewModel?.coordinator = self
        
        let mainScreenView = MainWeatherScreen(viewModel: mainScreenViewModel ?? WeatherViewModel(type: .geo))
        
        let mainScreenView2 = CityTableViewController(viewModel: secondViewModel)
        secondViewModel.coordinator = self
        tabBar.tintColor = .label
        view.backgroundColor = .systemYellow
        mainScreenView.tabBarItem.image = UIImage(systemName: "house")
        mainScreenView.title = "Home"
        
        mainScreenView2.tabBarItem.image = UIImage(systemName: "play.circle")
        mainScreenView2.title = "Table"

        self.viewControllers = [mainScreenView, mainScreenView2]
        
     
    }
    
    func reconfigure() {
        secondViewModel.updatePublisher
            .sink { city in
                print(city)
                self.mainScreenViewModel?.type = .city(city: city)
                self.mainScreenViewModel?.loadWeather(city)
            }
            .store(in: &cancellables)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureCoordinator(fetchType: .geo)
        reconfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

