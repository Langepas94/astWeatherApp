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

        let mainScreenView = MainWeatherScreen(viewModel: mainScreenViewModel)
        
        let mainScreenView2 = WeatherListFlowController()
        mainScreenView2.mainCoordinator = self
        
        mainScreenView.tabBarItem.image = UIImage(systemName: "house")
        mainScreenView.title = "Home"
        
        mainScreenView2.tabBarItem.image = UIImage(systemName: "play.circle")
        mainScreenView2.title = "Table"

        self.viewControllers = [mainScreenView, mainScreenView2]
        
        mainScreenViewModel.geoPublisher
            .sink(receiveValue: { model in
                mainScreenView2.reconfigure(city: model)
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

