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
    
    // MARK: - Variables
    
    var viewModel: IMainScreenWeatherViewModel
    var cancellables: Set<AnyCancellable> = []
    var name: String?
    
    let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = AppResources.MainScreen.Fonts.ViewController.cityNameLabel
        label.textAlignment = .center
        return label
    }()
    
    private let degreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = AppResources.MainScreen.Fonts.ViewController.degreesLabel
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionWeatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = AppResources.MainScreen.Fonts.ViewController.desxcriptionLabel
        return label
    }()
    
    private let weekTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(WeekWeatherCell.self, forCellReuseIdentifier: WeekWeatherCell.id)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        uiUpdate()
        loadData()
    }
    
    func loadData() {
        viewModel.loadWeather(from: nil)
    }
    
    init(viewModel: IMainScreenWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI

extension MainWeatherScreen {
    
    func configureScreenData(data: WeatherModel) {
        self.cityNameLabel.text = data.cityName
        self.degreesLabel.text = "\(String(describing: data.nowDegrees))" + "°C"
        self.descriptionWeatherLabel.text = data.description
        self.weekTable.reloadData()
    }
    
    func setupUI() {
        view.addSubview(cityNameLabel)
        view.addSubview(degreesLabel)
        view.addSubview(descriptionWeatherLabel)
        view.addSubview(weekTable)
        
        weekTable.dataSource = self
        weekTable.delegate = self
        
        tabBarItem.image = UIImage(systemName: "house")
        title = "Home"
        
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(AppResources.MainScreen.Constraints.ViewController.CityNameLabel.top)
        }
        
        degreesLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(AppResources.MainScreen.Constraints.ViewController.DegreesLabel.top)
            make.centerX.equalToSuperview()
        }
        
        descriptionWeatherLabel.snp.makeConstraints { make in
            make.top.equalTo(degreesLabel.snp.bottom).offset(AppResources.MainScreen.Constraints.ViewController.DescriptionLabel.top)
            make.centerX.equalToSuperview()
        }
        
        weekTable.snp.makeConstraints { make in
            make.top.equalTo(descriptionWeatherLabel.snp.bottom).offset(AppResources.MainScreen.Constraints.ViewController.Table.top)
            make.leading.equalToSuperview().offset(AppResources.MainScreen.Constraints.ViewController.Table.leading)
            make.trailing.equalToSuperview().offset(AppResources.MainScreen.Constraints.ViewController.Table.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func uiUpdate() {
        viewModel.updatePublisher
            .sink { [weak self] dataModel in
                DispatchQueue.main.async {
                    self?.configureScreenData(data: dataModel)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Setup Table
extension MainWeatherScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, 
                   numberOfRowsInSection section: Int) -> Int {
        viewModel.data?.weekData.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, 
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekTable.dequeueReusableCell(withIdentifier: WeekWeatherCell.id, 
                                                       for: indexPath) as? WeekWeatherCell else {return UITableViewCell() }
        
        if let data = viewModel.data {
            cell.configure(
                item: data.weekData[indexPath.row])
        }
        return cell
    }
}
