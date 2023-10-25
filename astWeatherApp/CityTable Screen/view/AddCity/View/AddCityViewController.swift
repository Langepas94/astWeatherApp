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

class AddCityViewController: UIViewController {
    
    let mainCityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Add city", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let degreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = ""
        label.font = .systemFont(ofSize: 37)
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
        label.textColor = .black
        label.numberOfLines = 1
        label.textAlignment = .left
        label.text = ""
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private let descriptionDegreesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let viewModel: AddCityViewModel
    
    var cancellables: Set<AnyCancellable> = []
    var callCity: ((String?) -> ())?
    var titleCity: String?
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        mainCityLabel.text = titleCity ?? ""
        getData()
        
    }
    
    func configurePopView(item: WeatherModel) {
        self.degreesLabel.text = String(item.nowDegrees)
        self.weatherImage.image = UIImage(named: item.icon ?? "")
        self.descriptionWeatherLabel.text = item.description
    }
    
    init(viewModel: AddCityViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonAction() {
        viewModel.addCity(city: city!)
        self.dismiss(animated: true)
    }
    
    func getData() {
        guard let citu = city else { return }
        viewModel.fetchWeather(city: citu)
        viewModel.updatePublisher
            .sink { model in
                self.configurePopView(item: model)
            }
            .store(in: &cancellables)
    }
}

extension AddCityViewController {
    func setupUI() {
        
        view.addSubview(mainCityLabel)
        view.addSubview(actionButton)
        view.addSubview(degreesLabel)
        view.addSubview(weatherImage)
        view.addSubview(descriptionWeatherLabel)
        view.addSubview(descriptionDegreesLabel)
        view.backgroundColor = .white
        
        actionButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.trailing.equalToSuperview().offset(-6)
        }
        mainCityLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.centerX.equalToSuperview()
        }
        
        weatherImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(12)
        }
        degreesLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(weatherImage.snp.trailing).offset(12)
        }
        
        descriptionWeatherLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalTo(weatherImage.snp.leading)
        }
    }
}

