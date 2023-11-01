//
//  ResultTableCitiesViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import SnapKit

protocol IResultTableCitiesViewController: UISearchController {
    func configureData(cityArray: [City])
    func reload()
}

final class ResultTableCitiesViewController:UISearchController, IResultTableCitiesViewController {
    
    // MARK: - elements
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: AppResources.TableWithCities.Labels.ResultTableCitiesViewController.resultTable)
        table.separatorStyle = .none
        return table
    }()
    
    private var filteredNames: [City] = []
    
    let viewController: IAddCityViewController
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: Flow
    func reload() {
        self.tableView.reloadData()
    }
    
    func configureData(cityArray: [City]) {
        self.filteredNames = cityArray
    }
    
    private func createConfig(index: Int) -> UIListContentConfiguration {
        var config = UIListContentConfiguration.cell()
        config.text = "\(String(describing: filteredNames[index].name ?? "")) || \(String(describing: filteredNames[index].country ?? ""))"
        return config
        
    }
    
    init(viewController: IAddCityViewController) {
        self.viewController = viewController
        super.init(nibName: nil, bundle: nil)
        searchBar.placeholder = AppResources.TableWithCities.Labels.ResultTableCitiesViewController.searchBarText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: extension Datasource & Delegate
extension ResultTableCitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredNames.count
    }
    
    // MARK: - Setup Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: AppResources.TableWithCities.Labels.ResultTableCitiesViewController.resultTable,
            for: indexPath)
        cell.selectionStyle = .none
        cell.contentConfiguration = createConfig(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewController.configureData(city: filteredNames[indexPath.row])
        viewController.modalPresentationStyle = .pageSheet
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true
        present(viewController, animated: true)
    }
}

// MARK: SetupUi
extension ResultTableCitiesViewController {
    func setupUi() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
    }
}
