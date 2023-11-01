//
//  AddCityViewController.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 24.10.2023.
//

import Foundation
import UIKit
import SnapKit
import Combine

protocol IAddCityViewController: UIViewController {
    func configureData(city: City)
    var viewModel: IAddCityViewModel { get set }
}

final class AddCityViewController: UIViewController, IAddCityViewController {
    
    // MARK: - Elements
    private let mainCityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppResources.TableWithCities.Fonts.AddCityViewController.cityName
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppResources.TableWithCities.TextConstant.AddCityViewController.buttonTitle, for: .normal)
        button.setTitleColor(AppResources.TableWithCities.Colors.buttonTitle, for: .normal)
        button.backgroundColor = AppResources.TableWithCities.Colors.buttonBackground
        button.layer.cornerRadius = AppResources.TableWithCities.Constraints.AddCityViewController.cornerRadius
        return button
    }()
    
    private let degreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.TableWithCities.Colors.textColor
        label.font = AppResources.TableWithCities.Fonts.AddCityViewController.degreeLabel
        return label
    }()
    
    private let weatherImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let descriptionWeatherLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.TableWithCities.Colors.textColor
        label.numberOfLines = 1
        label.textAlignment = .left
        label.font = AppResources.TableWithCities.Fonts.AddCityViewController.smallText
        return label
    }()
    
    private let descriptionDegreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.TableWithCities.Colors.textColor
        label.font = AppResources.TableWithCities.Fonts.AddCityViewController.smallText
        return label
    }()
    private var city: City?
    
    var viewModel: IAddCityViewModel
    var cancellables: Set<AnyCancellable> = []
  
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mainCityLabel.text = ""
        self.degreesLabel.text = ""
        self.descriptionWeatherLabel.text = ""
    }
    
    // MARK: - Flow
   private func configurePopView(item: WeatherModel) {
        self.mainCityLabel.text = item.cityName
        self.degreesLabel.text = item.textNowDescription
        self.weatherImage.image = UIImage(named: item.icon)
        self.descriptionWeatherLabel.text = item.description
    }
    
    func configureData(city: City) {
        self.city = city
    }
    
    init(viewModel: IAddCityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction() {
        guard let city = city else { return }
        viewModel.addCity(city: city)
        self.dismiss(animated: true)
    }
    
    private func getData() {
        guard let city = city else { return }
        viewModel.fetchWeather(city: city)
        viewModel.updatePublisher
            .sink { model in
                self.configurePopView(item: model)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Setup UI
extension AddCityViewController {
    private func setupUI() {
        
        view.addSubview(mainCityLabel)
        view.addSubview(actionButton)
        view.addSubview(degreesLabel)
        view.addSubview(weatherImage)
        view.addSubview(descriptionWeatherLabel)
        view.addSubview(descriptionDegreesLabel)
        view.backgroundColor = AppResources.TableWithCities.Colors.background
        
        mainCityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(AppResources.TableWithCities.Constraints.AddCityViewController.topOffsetLarge)
            make.centerX.equalToSuperview()
        }
        
        degreesLabel.snp.makeConstraints { make in
            make.top.equalTo(mainCityLabel.snp.bottom).offset(AppResources.TableWithCities.Constraints.AddCityViewController.typicalOffset)
            make.centerX.equalToSuperview()
        }
        
        weatherImage.snp.makeConstraints { make in
            make.top.equalTo(degreesLabel.snp.bottom).offset(AppResources.TableWithCities.Constraints.AddCityViewController.typicalOffset)
            make.centerX.equalToSuperview()
        }
        
        descriptionWeatherLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImage.snp.bottom).offset(AppResources.TableWithCities.Constraints.AddCityViewController.typicalOffset)
            make.centerX.equalToSuperview()
        }

        actionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(AppResources.TableWithCities.Constraints.AddCityViewController.typicalOffset)
            make.top.equalTo(descriptionWeatherLabel.snp.bottom).offset(AppResources.TableWithCities.Constraints.AddCityViewController.typicalOffset)
        }
    }
}

