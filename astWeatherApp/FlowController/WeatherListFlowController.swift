//
//  WeatherListFlowController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 25.10.2023.
//

import Foundation
import UIKit

protocol IWeatherListFlowController {
    func loadTableScreen()
    func goSearchScreen()
    func goAddCity(city: City)
    var mainCoordinator: FlowCoordinator? { get set }
}

class WeatherListFlowController: UINavigationController, IWeatherListFlowController {
    var mainCoordinator: FlowCoordinator?
    let db = CitiesDatabase()
    var cityViewModel: CityViewModel?
    
    func loadTableScreen() {
    
        let addViewModel: AddCityViewModel = AddCityViewModel()
        let addViewController = AddCityViewController(viewModel: addViewModel)
        addViewModel.coordinator = self
        let resultScreen = ResultTableCitiesViewController(viewController: addViewController)
        let searchScreenController = UISearchController(searchResultsController: resultScreen)
        cityViewModel?.testcoordinator = self
        let cityScreen = CityTableViewController(viewModel: cityViewModel!, searchController: searchScreenController)
        self.setViewControllers([cityScreen], animated: false)
    }
    
    func goSearchScreen() {
        //
    }
    
    func goAddCity(city: City) {
        db.addToFavorite(city: city)
        cityViewModel?.addToFavorite(city: city)
    }
    
    init() {
        cityViewModel = CityViewModel(db: db)
        super.init(nibName: nil, bundle: nil)
        loadTableScreen()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
