//
//  CityTableViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import Combine

class CityTableViewController: UIViewController {
    
//    var data: [WeatherModel] = [WeatherModel()]
    var viewModel: CityViewModel
    
    private lazy var searchController: UISearchController = {
        let vc = ResultTableCitiesViewController(viewModel: viewModel)
        return UISearchController(searchResultsController: vc)
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "kek")
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    var cancellables: Set<AnyCancellable> = []
    private var searchPublisher = PassthroughSubject<String, Never>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Favorites"
        searchController.searchBar.placeholder = "Search for your new favorite city"
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        viewModel.readFavorite()
        viewModel.$tableData
            .sink { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.loadAllCities()
        
        searchPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap({ $0 })
            .sink(receiveValue: {[weak self] (searchString: String) in
                guard let self = self else { return }
                viewModel.searchCities(query: searchString)
                viewModel.filteredNamesPublisher
                    .sink { cities in
                        let vc = self.searchController.searchResultsController as? ResultTableCitiesViewController
                        vc?.filteredNames = cities
                        vc?.tableView.reloadData()
                    }
                    .store(in: &cancellables)
            })
            .store(in: &cancellables)
    }
    
    init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CityTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kek", for: indexPath)
        cell.textLabel?.text = viewModel.tableData[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.tableData[indexPath.row]
        viewModel.pressCity(city: city)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           if editingStyle == .delete {
               
               viewModel.deleteCity(index: indexPath.row)

               // Animate the deletion of the row
               tableView.deleteRows(at: [indexPath], with: .fade)
           }
       }
    
}

extension CityTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text else { return }
        
        searchPublisher.send(text)
    }
}
