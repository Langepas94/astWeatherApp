//
//  CityTableViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import Combine

protocol ICityTableViewController: UIViewController {
    var viewModel: ICityViewModel { get set }
}

final class CityTableViewController: UIViewController, ICityTableViewController {
    
    // MARK: - Variables
    var viewModel: ICityViewModel
    
    private var searchView: IResultTableCitiesViewController
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: AppResources.TableWithCities.TextConstant.CityTableViewController.basicCellID)
        table.register(UITableViewCell.self, forCellReuseIdentifier: AppResources.TableWithCities.TextConstant.CityTableViewController.geoCellID)
        table.dataSource = self
        table.delegate = self
        return table
    }()
    
    private var cancellables: Set<AnyCancellable> = []
    private var searchPublisher = PassthroughSubject<String, Never>()
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchView
        searchView.searchResultsUpdater = self
        searchView.delegate = self
        setupUI()
        bindings()
    }
    
    // MARK: - Bindings
    private func bindings() {
        viewModel.tableDataPublisher
            .sink { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        viewModel.geoDataPublisher
            .sink { _ in
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .store(in: &cancellables)
        
        searchPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .compactMap({ $0 })
            .sink(receiveValue: { [weak self] (searchString: String) in
                guard let self = self else { return }
                viewModel.searchCities(query: searchString)
                viewModel.filteredNamesPublisher
                    .sink { [weak self] cities in
                        self?.searchView.configureData(cityArray: cities)
                        self?.searchView.reload()
                    }
                    .store(in: &cancellables)
            })
            .store(in: &cancellables)
    }
    
    // MARK: - Init's
    init(viewModel: ICityViewModel, searchView: IResultTableCitiesViewController) {
        self.searchView = searchView
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension CityTableViewController {
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = AppResources.TableWithCities.TextConstant.CityTableViewController.screenTitle
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - Table delegate & datasource
extension CityTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tableData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppResources.TableWithCities.TextConstant.CityTableViewController.geoCellID, for: indexPath)
            cell.textLabel?.text = viewModel.geoCityData?.cityName ?? "Globe"
            cell.imageView?.image = AppResources.TableWithCities.TextConstant.CityTableViewController.geoCellImage
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: AppResources.TableWithCities.TextConstant.CityTableViewController.basicCellID, for: indexPath)
            cell.textLabel?.text = viewModel.tableData[indexPath.row - 1].name
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            viewModel.pressGeo()
        } else {
            let city = viewModel.tableData[indexPath.row - 1]
            viewModel.pressCity(city: city)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if indexPath.row > 0 {
            if editingStyle == .delete {
                viewModel.deleteCity(index: indexPath.row - 1)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
}

// MARK: - SearchBar delegate
extension CityTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchPublisher.send(text)
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
