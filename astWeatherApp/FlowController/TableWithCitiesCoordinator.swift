//
//  WeatherListFlowController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 25.10.2023.
//

import Foundation
import UIKit
import Combine

protocol IWeatherListFlowController: UINavigationController {
    func loadTableScreen()
    func addCityToFavorite(city: City)
    var mainCoordinator: MainCoordinator? { get set }
    func reconfigureGeoCellFromMainGeoScreen(city: WeatherModel)
}

final class TableWithCitiesCoordinator: UINavigationController, IWeatherListFlowController {
    var mainCoordinator: MainCoordinator?
    var cityViewModel: ICityViewModel = CityViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Load Screen
    func loadTableScreen() {
        setupUI()
        let addViewModel: IAddCityViewModel = AddCityViewModel()
        addViewModel.coordinator = self
        let addViewController: IAddCityViewController = AddCityViewController(viewModel: addViewModel)
        
        let searchScreenController: IResultTableCitiesViewController = ResultTableCitiesViewController(viewController: addViewController)
        
        cityViewModel.coordinator = self
        
        let cityScreen: ICityTableViewController = CityTableViewController(viewModel: cityViewModel, searchView: searchScreenController)
        self.setViewControllers([cityScreen], animated: false)
    }
    
    private func setupBind() {
        cityViewModel.reloadPublisher
            .sink(receiveValue: { [weak self] city in
                self?.mainCoordinator?.reconfigureMainScreen(city: city)
            })
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        tabBarItem.image = AppResources.TableWithCities.Labels.TabBar.image
        title = AppResources.TableWithCities.Labels.TabBar.title
    }
    
    // MARK: Add to favorite
    func addCityToFavorite(city: City) {
        cityViewModel.addToFavorite(city: city)
    }
    
    //MARK: - Coordinator flow
    func geoCellPressed() {
        mainCoordinator?.reconfigureMainScreen(city: nil)
    }
    
    func reconfigureGeoCellFromMainGeoScreen(city: WeatherModel) {
        cityViewModel.setGeoCity(city: city)
    }
    
    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        loadTableScreen()
        setupBind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
