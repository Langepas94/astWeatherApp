//
//  WeatherTableViewCell.swift
//  astWeatherApp
//
//  Created by Артём Тюрморезов on 18.10.2023.
//

import Foundation
import UIKit

class WeekWeatherCell: UITableViewCell {
    
    static let id = "WeekWeatherCellID"
    
    // MARK: - Variables
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = AppResources.MainScreen.Labels.WeatherCell.defaulCellLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.MainScreen.Colors.WeatherCell.cellTextColor
        label.font = AppResources.UniversalElements.Fonts.cellFont
        return label
    }()
    
    let weatherImage: UIImageView = {
        let image = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        image.contentMode = .center
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let degreeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = AppResources.MainScreen.Colors.WeatherCell.cellTextColor
        label.font = AppResources.UniversalElements.Fonts.cellFont
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIs()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Setup UI
extension WeekWeatherCell {
    func setupUIs() {
        contentView.addSubview(timeLabel)
        contentView.addSubview(weatherImage)
        contentView.addSubview(degreeLabel)
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(AppResources.MainScreen.Constraints.WeatherCell.leadingOffset)
            make.height.equalTo(AppResources.MainScreen.Constraints.WeatherCell.height)
            make.centerY.equalToSuperview()
        }
        
        weatherImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalToSuperview()
        }
        
        degreeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(AppResources.MainScreen.Constraints.WeatherCell.trailingOffset)
            make.height.equalTo(AppResources.MainScreen.Constraints.WeatherCell.height)
            make.centerY.equalToSuperview()
        }
    }
    
    func configure(item: List) {
        let date = item.dt ?? 0
        let convertDate = Date(timeIntervalSince1970: TimeInterval(date))
        let formats = convertDate.formatted(.dateTime.day().month(.twoDigits).hour().minute())
        self.timeLabel.text = String(formats)
        self.weatherImage.image = UIImage(named: item.weather?[0].icon ?? "")
        self.degreeLabel.text = String(item.main?.temp?.rounded(numAfter: 1) ?? 0.0) + "°"
    }
}
