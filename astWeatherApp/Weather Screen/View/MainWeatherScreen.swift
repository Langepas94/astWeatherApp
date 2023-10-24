//
//  ViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 28.09.2023.
//

import UIKit
import Combine
import SnapKit
import CoreLocation

class MainWeatherScreen: UIViewController {
    
    // MARK: - Variables
    
    var viewModel: IMainScreenWeatherViewModel
    var cancellables: Set<AnyCancellable> = []
    let locationManager = CLLocationManager()
    var data: WeatherModel = WeatherModel()
    var name: String?
    
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
        table.register(WeekWeatherCell.self, forCellReuseIdentifier: WeekWeatherCell.id)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataType()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        setupUI()
        uiUpdate()
        
    }
    
    func dataType() {
        switch viewModel.type {
        case .city(let city):
            viewModel.loadWeather(city)
        case .geo:
            requestGeoSwitcher()
        }
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
    
    func configureScreenData() {
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
        
        cityNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
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
            }
            .store(in: &cancellables)
    }
}

// MARK: - Setup Table
extension MainWeatherScreen: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.weekData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = weekTable.dequeueReusableCell(withIdentifier: WeekWeatherCell.id, for: indexPath) as? WeekWeatherCell else {return UITableViewCell() }
        
        cell.configure(item: data.weekData[indexPath.row])
        return cell
    }
}

extension MainWeatherScreen: CLLocationManagerDelegate {
    
    func requestGeoAccess() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestGeoSwitcher() {
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            requestGeoAccess()
            getGeo()
        case .restricted:
            requestGeoAccess()
            getGeo()
        case .denied:
            requestGeoAccess()
            getGeo()
        case .authorizedAlways:
            getGeo()
        case .authorizedWhenInUse:
            getGeo()
        @unknown default:
            requestGeoAccess()
        }
    }
    
    func getGeo() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            viewModel.loadWeather(location)
            locationManager.stopUpdatingLocation()
        }
    }
}
