//
//  ViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 28.09.2023.
//

import UIKit
import Combine
import SnapKit

protocol IMainWeatherView {
    func configureTabBarItem()
    func loadData()
    func bind()
}

final class MainWeatherScreen: UIViewController {
    
    // MARK: - Variables
    
    var viewModel: IMainScreenWeatherViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private let cityNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.MainScreen.Colors.ViewController.label
        label.font = AppResources.MainScreen.Fonts.ViewController.cityNameLabel
        label.textAlignment = .center
        return label
    }()
    
    private let degreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.MainScreen.Colors.ViewController.label
        label.font = AppResources.MainScreen.Fonts.ViewController.degreesLabel
        label.textAlignment = .center
        return label
    }()
    
    private let maxMinDegreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.MainScreen.Colors.ViewController.label
        label.font = AppResources.MainScreen.Fonts.ViewController.desxcriptionLabel
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionWeatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.MainScreen.Colors.ViewController.label
        label.font = AppResources.MainScreen.Fonts.ViewController.desxcriptionLabel
        return label
    }()
    
    private let weekTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(WeekWeatherCell.self, forCellReuseIdentifier: WeekWeatherCell.id)
        table.separatorStyle = .none
        table.layer.cornerRadius = 20
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
        loadData()
    }
    
    init(viewModel: IMainScreenWeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MainWeatherScreen: IMainWeatherView {
    
    func loadData() {
        viewModel.loadWeather(type: .geo)
    }
    
    func configureTabBarItem() {
        tabBarItem.image = AppResources.MainScreen.Labels.TabBar.image
        title = AppResources.MainScreen.Labels.TabBar.title
    }
    
    func bind() {
        viewModel.updatePublisher
            .sink { [weak self] dataModel in
                DispatchQueue.main.async {
                    self?.configureScreenData(data: dataModel)
                }
            }
            .store(in: &cancellables)
    }
}

// MARK: - Setup UI

extension MainWeatherScreen {
    
    private func configureScreenData(data: WeatherModel) {
        self.cityNameLabel.text = data.cityName
        self.degreesLabel.text = data.textNowDescription
        self.descriptionWeatherLabel.text = data.description
        self.maxMinDegreesLabel.text = data.maxMinDescription
        self.weekTable.reloadData()
    }
    
    private func setupUI() {
        configureTabBarItem()
        
        view.addSubview(cityNameLabel)
        view.addSubview(degreesLabel)
        view.addSubview(descriptionWeatherLabel)
        view.addSubview(weekTable)
        view.addSubview(maxMinDegreesLabel)
        
        weekTable.dataSource = self
        weekTable.delegate = self
        
        view.backgroundColor = .systemBackground
        
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(AppResources.MainScreen.Constraints.ViewController.CityNameLabel.top)
        }
        
        degreesLabel.snp.makeConstraints { make in
            make.top.equalTo(cityNameLabel.snp.bottom).offset(AppResources.MainScreen.Constraints.ViewController.DegreesLabel.top)
            make.centerX.equalToSuperview()
        }
        
        maxMinDegreesLabel.snp.makeConstraints { make in
            make.top.equalTo(degreesLabel.snp.bottom).offset(AppResources.MainScreen.Constraints.ViewController.DescriptionLabel.top)
            make.centerX.equalToSuperview()
        }
        
        descriptionWeatherLabel.snp.makeConstraints { make in
            make.top.equalTo(maxMinDegreesLabel.snp.bottom).offset(AppResources.MainScreen.Constraints.ViewController.DescriptionLabel.top)
            make.centerX.equalToSuperview()
        }
        
        weekTable.snp.makeConstraints { make in
            make.top.equalTo(descriptionWeatherLabel.snp.bottom).offset(AppResources.MainScreen.Constraints.ViewController.Table.top)
            make.leading.equalToSuperview().offset(AppResources.MainScreen.Constraints.ViewController.Table.leading)
            make.trailing.equalToSuperview().offset(AppResources.MainScreen.Constraints.ViewController.Table.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
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
                                                       for: indexPath) as? WeekWeatherCell else {
                                                        return UITableViewCell() }
        
        if let data = viewModel.data {
            cell.configure(
                item: data.weekData[indexPath.row])
        }
        return cell
    }
}
