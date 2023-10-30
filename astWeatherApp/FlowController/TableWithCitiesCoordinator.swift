//
//  WeatherListFlowController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 25.10.2023.
//

import Foundation
import UIKit
import Combine

protocol IWeatherListFlowController {
    func loadTableScreen()
    func goAddCity(city: City)
    var mainCoordinator: MainCoordinator? { get set }
}

class TableWithCitiesCoordinator: UINavigationController, IWeatherListFlowController {
    var mainCoordinator: MainCoordinator?
    var cityViewModel: CityViewModel = CityViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    func loadTableScreen() {
    
        var addViewModel: IAddCityViewModel = AddCityViewModel()
        addViewModel.coordinator = self
        let addViewController = AddCityViewController(viewModel: addViewModel)
      
        let resultScreen = ResultTableCitiesViewController(viewController: addViewController)
        let searchScreenController: UISearchController = UISearchController(searchResultsController: resultScreen)
        
        cityViewModel.testcoordinator = self
        let cityScreen = CityTableViewController(viewModel: cityViewModel, searchController: searchScreenController)
        setupUI()
        self.setViewControllers([cityScreen], animated: false)
    }
    
    private func setupBind() {
        cityViewModel.reloadPublisher
            .sink(receiveValue: { [weak self] city in
                self?.mainCoordinator?.reconfigure(city: city)
            })
            .store(in: &cancellables)
    }
    
    func goAddCity(city: City) {
        cityViewModel.addToFavorite(city: city)
    }
    
    private func setupUI() {
        tabBarItem.image = UIImage(systemName: "play.circle")
        title = "Table"
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        loadTableScreen()
        setupBind()
    }
    
    func pressGeo() {
        mainCoordinator?.reconfigure(city: nil)
    }
    
    func reconfigure(city: WeatherModel) {
        cityViewModel.setGeoCity(city: city)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
