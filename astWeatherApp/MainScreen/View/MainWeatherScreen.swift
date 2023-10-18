//
//  ViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 28.09.2023.
//

import UIKit
import Combine
import SnapKit

class MainWeatherScreen: UIViewController {
    
    let viewModel = WeatherViewModel()
    var cancellables: Set<AnyCancellable> = []
    
    var data: WeatherModel = WeatherModel()
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 32)
        label.textAlignment = .center
        return label
    }()
    
    private let degreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 63)
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionWeatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 13)
        return label
    }()
    
    private let weekTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(FutureTimeWeatherCell.self, forCellReuseIdentifier: FutureTimeWeatherCell.id)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        uiUpdate()
    }
}

// MARK: - Setup UI

extension MainWeatherScreen {
    
    func configureScreenData() {
        self.cityNameLabel.text = data.cityName
        self.degreesLabel.text = "\(String(describing: data.nowDegrees))"
        self.descriptionWeatherLabel.text = data.description
    }
    
    func setupUI() {
        view.addSubview(cityNameLabel)
        view.addSubview(degreesLabel)
        view.addSubview(descriptionWeatherLabel)
        view.addSubview(weekTable)
        
        weekTable.dataSource = self
        weekTable.delegate = self
        
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(30)
        }
        
        degreesLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
        }
        
        descriptionWeatherLabel.snp.makeConstraints { make in
            make.top.equalTo(degreesLabel.snp.bottom).offset(22)
            make.centerX.equalToSuperview()
        }
        
        weekTable.snp.makeConstraints { make in
            make.top.equalTo(descriptionWeatherLabel.snp.bottom).offset(22)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func uiUpdate() {
        viewModel.updatePublisher
            .sink { dataModel in
                self.data = dataModel
                self.configureScreenData()
                self.weekTable.reloadData()
            }
            .store(in: &cancellables)
    }
}

extension MainWeatherScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.weekData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekTable.dequeueReusableCell(withIdentifier: FutureTimeWeatherCell.id, for: indexPath) as? FutureTimeWeatherCell else {return UITableViewCell() }
        
        cell.configure(item: data.weekData[indexPath.row])
        return cell
    }
    
    
}
