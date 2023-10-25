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

class FlowCoordinator: UITabBarController {
    
//    var secondViewModel = CityViewModel()
    private var cancellables = Set<AnyCancellable>()
    var mainScreenViewModel: WeatherViewModel?
    
    func configureCoordinator() {
        
        mainScreenViewModel = WeatherViewModel()
        mainScreenViewModel?.coordinator = self
//        let mainScreenView = WeatherListFlowController()
        let mainScreenView = MainWeatherScreen(viewModel: mainScreenViewModel!)
        
//        let mainScreenView2 = UINavigationController(rootViewController: CityTableViewController(viewModel: secondViewModel))
        let mainScreenView2 = WeatherListFlowController()
        mainScreenView2.mainCoordinator = self
//        secondViewModel.coordinator = self
        tabBar.tintColor = .label
        
        mainScreenView.tabBarItem.image = UIImage(systemName: "house")
        mainScreenView.title = "Home"
        
        mainScreenView2.tabBarItem.image = UIImage(systemName: "play.circle")
        mainScreenView2.title = "Table"

        self.viewControllers = [mainScreenView, mainScreenView2]
        
    }
    
    func reconfigure() {
//        secondViewModel.reloadPublisher
//            .sink { city in
//                self.mainScreenViewModel?.loadWeather(from: city)
//            }
//            .store(in: &cancellables)
        
//        mainScreenViewModel?.updatePublisher
//            .sink(receiveValue: { cityModel in
////                self.secondViewModel.addGeoCity(city: cityModel)
//            })
//            .store(in: &cancellables)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureCoordinator()
        reconfigure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

