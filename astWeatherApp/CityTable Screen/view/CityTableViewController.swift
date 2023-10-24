//
//  CityTableViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit

class CityTableViewController: UIViewController {
    
    var cityArray = ["Langepas", "Moscow", "New York", "Volgograd"]
    var viewModel: CityViewModel
    
    private var tableView: UITableView = {
        let table = UITableView()
        table.showsVerticalScrollIndicator = false
        table.showsHorizontalScrollIndicator = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "kek")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
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
        cityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kek", for: indexPath)
        cell.textLabel?.text = cityArray[indexPath.row]
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = cityArray[indexPath.row]
        viewModel.pressCity(city: city)
    }
    
}
