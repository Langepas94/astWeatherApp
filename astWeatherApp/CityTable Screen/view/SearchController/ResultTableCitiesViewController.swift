//
//  ResultTableCitiesViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import SnapKit

class ResultTableCitiesViewController: UIViewController {
    // MARK: - elements
    let tableView: UITableView = {
       let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "TableView")
        table.separatorStyle = .none
//        table.backgroundColor = .black.withAlphaComponent(0.1)
        return table
    }()
    
    public var filteredNames: [City] = []
    var viewModel: CityViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        tableView.dataSource = self
        tableView.delegate = self
    }
    init(viewModel: CityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: extension Datasource
extension ResultTableCitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredNames.count
    }
    
 // MARK: - Setup Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TableView",
            for: indexPath)
        
        var config = cell.defaultContentConfiguration()
        config.text = "\(String(describing: filteredNames[indexPath.row].name ?? "")) || \(String(describing: filteredNames[indexPath.row].country ?? ""))"
        cell.selectionStyle = .none
        cell.contentConfiguration = config
//        cell.textLabel?.text = "\(filteredNames[indexPath.row].name)"
//        cell.backgroundColor = .black.withAlphaComponent(0.3)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = AddCityViewController(viewModel: viewModel)
////        vc.callCity = self.callCity
        vc.city = filteredNames[indexPath.row]
        vc.titleCity = filteredNames[indexPath.row].name
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.delegate = self
        vc.preferredContentSize = CGSize(width: 330, height: 120)
        vc.popoverPresentationController?.sourceRect = self.tableView.rectForRow(at: indexPath)
        vc.popoverPresentationController?.sourceView = self.tableView
            present(vc, animated: true)
    }
    

}

extension ResultTableCitiesViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
}

// MARK: SetupUi
extension ResultTableCitiesViewController {
    func setupUi() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
