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
        return table
    }()
    
    let viewController: AddCityViewController
    
    public var filteredNames: [City] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUi()
        tableView.dataSource = self
        tableView.delegate = self
    }
    init(viewController: AddCityViewController) {
        self.viewController = viewController
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
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = viewController
//        vc.city = filteredNames[indexPath.row]
//        vc.titleCity = filteredNames[indexPath.row].name
        vc.configureData(city: filteredNames[indexPath.row])
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
