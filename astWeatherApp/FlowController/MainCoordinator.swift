//
//  FlowCoordinator.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import Combine

protocol IMainCoordinator {
    func configureTabBar()
}

final class MainCoordinator: UITabBarController, IMainCoordinator {
    
    // MARK: - Variables
    private var cancellables = Set<AnyCancellable>()
    private var mainScreenViewModel: IMainScreenWeatherViewModel = WeatherViewModel()
    private let tableWithCitiesViewController: IWeatherListFlowController = TableWithCitiesCoordinator()
    
    // MARK: Flow
    func configureTabBar() {
        let mainWeatherViewController = MainWeatherScreen(viewModel: mainScreenViewModel)
        setupBind(viewController: tableWithCitiesViewController)
        self.viewControllers = [mainWeatherViewController, tableWithCitiesViewController]
    }
    
    private func configureCoordinator() {
        mainScreenViewModel.coordinator = self
        tableWithCitiesViewController.mainCoordinator = self
    }
    
    private func setupBind(viewController: IWeatherListFlowController) {
        mainScreenViewModel.geoPublisher
            .sink(receiveValue: { model in
                viewController.reconfigureGeoCellFromMainGeoScreen(city: model)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Reconfigure main screen
    func reconfigureMainScreen(city: City?) {
        switch city {
        case .none:
            mainScreenViewModel.loadWeather(type: .geo)
        case .some( let city):
            mainScreenViewModel.loadWeather(type: .city(city: city))
        }
    }
    
    //MARK: - Init's
    init() {
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
        configureCoordinator()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

